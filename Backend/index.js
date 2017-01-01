var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

// Check this out:
// https://gist.github.com/dskanth
// To make a private chat room, use rooms... use answer with most points
// http://stackoverflow.com/questions/17476294/how-to-send-a-message-to-a-particular-client-with-socket-io

app.get('/', function (req, res) {
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){

  //var server_username = ""

  io.emit("connect");

  socket.on("initialize", function(username) {
    socket.username = username;
    io.emit("connected", username);
  });

  socket.on("chat message", function(username, msg) {
    io.emit("chat message", username, msg);
  });

  socket.on('disconnect', function() {
    io.emit("disconnected", socket.username);
  });

});

var port = 3000;
http.listen(port, function() {
  console.log("App listening on port " + port);
});
