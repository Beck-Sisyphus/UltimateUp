var fetch = require('request-promise');
var querystring = require('querystring');

var conf, r, db, users, fb_tokens, access_tokens;

var handle;

module.exports = function(config, rethink) {
  conf = config;
  r = rethink;
  db = r.db('ut');
  users = db.table('users');
  fb_tokens = db.table('fb_tokens');
  access_tokens = db.table('access_tokens');

  return handle;
};

handle = function(soc) {
  // facebook login

  soc.on("fb_login", function(req, cb) {
    // FIXME: query sanitization
    var fb_token = req.fb_token || null;
    var fb_id = req.fb_id || null;
    var user_id = req.user_id || null;
    var fb_res;

    if (!fb_token || !fb_id) {
      throw "No fb_token or fb_id provided";
    }

    fetch({
      url: "https://graph.facebook.com/oauth/access_token",
      qs: {
        grant_type: "fb_exchange_token",
        client_id: conf.facebook.app_id,
        client_secret: conf.facebook.app_secret,
        fb_exchange_token: fb_token
      }
    }).then(querystring.parse).then(function(res) {
      if (!res.access_token) {
        throw "No access_token on successful login";
      }
      fb_res = res;
      // check if access token belongs to the user
      return fetch({
        url: "https://graph.facebook.com/" + fb_id + "",
        qs: {
          access_token: fb_res.access_token
        }
      });
    }).then(function(res) {
      // 200 - success

      // check if user exists
      return users.getAll(fb_id, {index: 'facebook_id'}).run();
    }).then(function(res) {
      if (res.length === 0) {
        // no such user - create one
        return users.insert({
          facebook_id: fb_id,
          }).run().then(function(res) {
            if (res.errors) {
              throw "Failed to insert new user";
            }
            return res.generated_keys[0];
          });
      }
      else if (user_id !== null && res[0].id != user_id) {
        // error
        throw "id mismatch: " +  res.id + " " + user_id;
      } else {
        return res.id;
      }
    }).then(function (id) {
      var expiration =  // token expiration time
        r.epochTime(fb_res.expires * 1000 + Date.now());
      // update token
      return Promise.all([
        access_tokens.insert({
          id: id,
          token: r.uuid(),
          expiration: expiration
        }, {conflict: 'replace', returnChanges: true}).run(),
        fb_tokens.insert({
          id: id,
          token: fb_res.access_token,
          expiration: expiration
        }, {conflict: 'replace'}).run()
      ]);
    }).then(function(res) {
      if (res[0].errors || res[1].errors) {
        throw "Failed to update fb token";
      }
      var new_token = res[0].changes.new_val;

      cb({
        status: true,
        user_id: new_token.id,
        access_token: new_token.token
      });
    }).catch(function(err) {
      console.error("[fb_login] error:", err);
      cb({"status": false});
    });
  });




};
