var fetch = require('request-promise');

var conf, r;

var handle;

module.exports = function(config, rethink) {
  conf = config;
  r = rethink;
  return handle;
};

handle = function(soc) {
  // facebook login

  soc.on("hello world", function(req, cb) {
     console.info('req', req);
     console.info('cb', cb);
     cb(req);
  });
  soc.on("login", function(req, cb) {
    var fb_token = req.fb_token || null;
    var user_id = req.user_id || null;

    if (!fb_token) {
      return cb({"status": false});
    }

    fetch({
      url: "http://graph.facebook.com/oauth/access_token",
      qs: {
        grant_type: "fb_exchange_token",
        client_id: conf.FACEBOOK_APP_ID,
        client_secret: conf.FACEBOOK_APP_SECRET,
        fb_exchange_token: fb_token
      }
    }).then(JSON.parse).then(function(res) {
      // {"access_token":"...", "expires_in":..., "machine_id":"..."}
      if (!res.access_token) {
        throw "No access_token on successful login";
      }
      // TODO: send to db
    }).catch(function(err) {
      console.error(err);
      return cb({"status": false});
    });
  });




};
