var io = require('socket.io-client');
var testData = require("./test-data");
var socketURL = "http://127.0.0.1/mobi";
var options = {
  transports: ['websocket'],
  'force new connection': true
};


var socketConnect = function(cb) {
  var client = io.connect(socketURL, options);

  client.on('connect', function() {
    cb(client);
  });

  return client;
};

var connectWithLogin = function(id, token, cb) {
  var opts = Object.create(options);
  opts.extraHeaders = {
    "X-Access-Token": token,
    "X-User-ID": id
  };
  var client = io.connect(socketURL, opts);

  client.on('connect', function() {
    cb(client);
  });

  return client;
};

describe("Connection", function() {
  it("should be able to handle new connections", function(done) {
    socketConnect(function(client) {
      client.disconnect();
      done();
    });
  });
});

describe("Login", function() {

  it("should be able to login via fb", function(done) {
    socketConnect(function(client) {
      client.emit("fb_login", {
        fb_id: testData.fb_id,
        fb_token: testData.fb_token
      }, function(res) {
        expect(res.status).toBeTruthy();
        console.info(res);
        client.disconnect();
        done();
      });
    });
  });

  it("should be able to login via token", function() {
    socketConnect(function(client) {
      client.emit("fb_login", {
        fb_id: testData.fb_id,
        fb_token: testData.fb_token
      }, function(res) {
        client.disconnect();
        connectWithLogin(res.user_id, res.access_token, function(client2) {
          client2.disconnect();
          done();
        }).on("error", function(e) {
          throw e;
        });
      });
    });
  });
});
