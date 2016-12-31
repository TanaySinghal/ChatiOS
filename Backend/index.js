var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function (req, res) {
  //res.send('<h1> Hello world </h1>');
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){

  var server_username = ""

  io.emit("connect");

  socket.on("initialize", function(username) {
    server_username = username;
    io.emit("connected", username);
  });

  socket.on("chat message", function(username, msg) {
    io.emit("chat message", username, msg);
  });

  socket.on('disconnect', function(){
    io.emit("disconnected", server_username);
  });

});

var port = 3000;
http.listen(port, function() {
  console.log("App listening on port " + port);
});
