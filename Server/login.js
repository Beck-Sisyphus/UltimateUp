// login module: handles facebook login as well as normal login, which happens
// every time after a socket.io connection is established

// general dependencies
// --------------------
var fetch = require('request-promise');  // for making http requests
var querystring = require('querystring');  // for parsing querystrings
var session = require('./session');  // session store

// global variables
// ----------------
var conf;  // configuration
var r;  // rethinkdb server
var db;  // the `ut` main db of the db server
var users;  // the `users` table of the main db
var fb_tokens;  // the `fb_tokens` table of the main db
var access_tokens;  // the `access_tokens` table of the main db

var handle;  // main handler function
var preauth;  // normal login function

// dependency injection
// each module depends upon the server-wide configurations and the db
// so, it receives them during initialization (the following function)

// initialization function
// -----------------------

// each module must export a single function (init function)
// it takes two params (server-wide configurations and the db)
// and returns an object, which contains all the public functions
//  it intends to export.

// in general, a module should export a `handle` function,
// which is called when a new connection is established
// and do things with the socket.io `socket`.
module.exports = function(config, rethink) {
  conf = config;
  r = rethink;
  db = r.db('ut');
  users = db.table('users');
  fb_tokens = db.table('fb_tokens');
  access_tokens = db.table('access_tokens');

  return {handle: handle, preauth: preauth};
};

// the normal login process
// grabs special http headers during post-handshake
// and attempt to log the user in with it

// check trello board for details (card `login`)
preauth = function(soc, next) {
  // FIXME: no query sanitization
  // this is a potential security flaw!!
  var user_id = soc.request.headers["x-user-id"] || "";
  var access_token = soc.request.headers["x-access-token"] || "";

  if (user_id || access_token) {
    // has login

    if (!user_id || !access_token) {
      console.error("[login] No fb_token or fb_id provided");
      return next({name: "bad login parameters"});
    }

    // ask db for info about the access token
    tokens.get(access_token).run()
    .then(function(res) {
      if (res === null) {
        throw "Access_token not found in table";
      }
      else if (res.id != user_id) {
        throw "user id mismatch: " + res.id + ", " + user_id;
      }
      else if (res.expiration.valueOf() < Date.now()) {
        throw "Expired token: " + res.expiration;
      }
      // success
      session.setAuthenticated(soc);
      next();
    })
    .catch(function(err) {
      console.error("[login] error:", err);
      next({name: "login failed"});
    });
  }
  else {
    // no login
    next();
  }
};

// each module's `handle` is called after a connection is established
// with the param `soc`
// usually, a module will want to attach event handlers to `soc` in this place
handle = function(soc) {

  // in socket.io, to listen on a request URI,
  // you attach a new event handler for this URI on `soc`

  // facebook login
  // attempts to log user in with their facebook access token
  // check trello board for details (card `fb_login`)
  soc.on("fb_login", function(req, cb) {
    // FIXME: query sanitization
    // this is a potential security flaw!!
    var fb_token = req.fb_token || null;
    var fb_id = req.fb_id || null;
    var user_id = req.user_id || null;
    var fb_res;  // stores fb's response json

    if (!fb_token || !fb_id) {
      console.error("[fb_login] No fb_token or fb_id provided");
      return cb({status: false});
    }

    // ask facebook for a long-term access token
    // by showing them the short-term token provided by the user
    fetch({
      url: "https://graph.facebook.com/oauth/access_token",
      qs: {
        grant_type: "fb_exchange_token",
        client_id: conf.facebook.app_id,
        client_secret: conf.facebook.app_secret,
        fb_exchange_token: fb_token
      }
      // check for response
    }).then(querystring.parse).then(function(res) {
      if (!res.access_token) {
        throw "No access_token on successful login";
      }
      // store the response for later use
      fb_res = res;
      // make some random req to check if access token belongs to the user
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
        // we ask the db to insert a new document without a primary key
        // so it generates one and give it to us
        return users.insert({
          facebook_id: fb_id,
          }).run()
          .then(function(res) {
            if (res.errors) {
              throw "Failed to insert new user";
            }
            // server-generated user id
            return res.generated_keys[0];
          });
      }
      else if (user_id !== null && res[0].id != user_id) {
        // error
        // the user is trying to login with someone else's user id!
        throw "id mismatch: " +  res[0].id + " " + user_id;
      } else {
        return res[0].id;
      }
    }).then(function (id) {
      var expiration =  // token expiration time
        r.epochTime(fb_res.expires * 1000 + Date.now());
      // update token
      return Promise.all([
        // creates a new ultimateup access token
        access_tokens.insert({
          id: id,
          token: r.uuid(),  // ask the server to generates a token
          expiration: expiration
        }, {conflict: 'replace', returnChanges: true}).run(),
        // while records the facebook access token
        fb_tokens.insert({
          id: id,
          token: fb_res.access_token,
          expiration: expiration
        }, {conflict: 'replace'}).run()
      ]);
      // check for errors and make response
    }).then(function(res) {
      if (res[0].errors || res[1].errors) {
        throw "Failed to update fb token";
      }
      // generated ultimateup access token
      var new_token = res[0].changes[0].new_val;

      session.setAuthenticated(soc);
      cb({
        status: true,
        user_id: new_token.id,
        access_token: new_token.token
      });
    }).catch(function(err) {
      console.error("[fb_login] error:", err);
      cb({status: false});
    });
  });

  // ignore this part
  // // normal login
  //
  // soc.on("login", function(req, cb) {
  //   // FIXME: query sanitization
  //   var user_id = req.user_id || null;
  //   var access_token = req.access_token || null;
  //
  //   tokens.get(access_token).run()
  //   .then(function(res) {
  //     if (res === null) {
  //       throw "Access_token not found in table";
  //     }
  //     else if (res.id != user_id) {
  //       throw "user id mismatch: " + res.id + ", " + user_id;
  //     }
  //     else if (res.expiration.valueOf() < Date.now()) {
  //       throw "Expired token: " + res.expiration;
  //     }
  //     cb({status: true, user_id: res.id});
  //   })
  //   .catch(function(err) {
  //     console.error("[login] error:", err);
  //     cb({status: false});
  //   });
  // });


};
