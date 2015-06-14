// read site-wide configurations
var conf = require('./config');

// general dependencies
var app = require('http').createServer(handler);
var io = require('socket.io')(app, conf.io);
var fs = require('fs');
var r = require('rethinkdbdash')(conf.rethink);

// app components

var login = require('./login')(conf, r);

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


// default socket: /mobi
io.of('mobi')
.use(login.preauth)
.on('connection', function (socket) {
  console.info("[mobi] new connection");
  // attaching components
  login.handle(socket);

});

// starting server
app.listen(80);
