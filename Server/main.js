// read site-wide configurations
var conf = require('./config');

// general dependencies
var app = require('http').createServer(handler);  // http server for debugging
var io = require('socket.io')(app, conf.io);  // socket.io server
var fs = require('fs');  // the fs module
var r = require('rethinkdbdash')(conf.rethink);  // rethinkdb server

// initialize each component

var login = require('./login')(conf, r);

// debugging: used to check if server is online
function handler (req, res) {
  fs.readFile(__dirname + '/index.html',
  function (err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }

    res.writeHead(200);
    res.end(data);
  });
}

// configuring socket.io
// default socket: /mobi
io.of('mobi')
// normal login happens after each connection is established
.use(login.preauth)
.on('connection', function (socket) {
  console.info("[mobi] new connection");
  // attaching components
  login.handle(socket);

});

// starting server
app.listen(80);
