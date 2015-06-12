// read site-wide configurations
var conf = require('./config');

// general dependencies
var app = require('http').createServer(handler)
var io = require('socket.io')(app);
var fs = require('fs');
var r = require('rethinkdbdash')(conf.rethink);

// app components

var login = require('./login')(conf, r);

console.info(login);

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
io.of('mobi').on('connection', function (socket) {
  // attaching components
  socket.emit("callback", {this: "that"});
  login(socket);
  
});

// starting server
app.listen(80);
