var fetch = require('request-promise');
var querystring = require('querystring');

var conf, r, db, users;

var handle;

module.exports = function(config, rethink) {
  conf = config;
  r = rethink;
  db = r.db('ut');
  users = db.table('users');
  fb_tokens = db.table('fb_tokens');
  return handle;
};

handle = function(soc) {
  // facebook login

  soc.on("hello world", function(req, cb) {
     console.info('req', req);
     console.info('cb', cb);
     cb(req);
  });
  soc.on("fb_login", function(req, cb) {
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
      // {"access_token":"...", "expires_in":..., "machine_id":"..."}
      if (!res.access_token) {
        throw "No access_token on successful login";
      }
      console.info(res);
      fb_res = res;
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
      else if (res.id != user_id) {
        // error
        throw "id mismatch: " +  res.id + " " + user_id;
      } else {
        return res.id;
      }
    }).then(function (id) {
      user_id = id;
      // update token
      return fb_tokens.insert({
        id: id,
        token: fb_res.access_token,
        expiration: fb_res.expires * 1000 + Date.now()
      }, {conflict: 'replace'}).run();
    }).then(function(res) {
      if (res.errors) {
        throw "Failed to update fb token";
      }

      cb({
        status: true,
        user_id: user_id,
        access_token: 'TODO'
      });
    }).catch(function(err) {
      console.error("[fb_login] error:", err);
      cb({"status": false});
    });
  });




};
