var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function (req, res) {
  //res.send('<h1> Hello world </h1>');
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){

  // How to create user from front end instead...
  var username = "user_" + (Math.floor(Math.random()*90000) + 10000).toString();
  io.emit("connected", username);

  // How to remove username: uncomment the below, comment the above
  // Add username and "emit" to front end on init
  /*socket.on("connect", function() {

  });*/

  socket.on("chat message", function(msg) {
    io.emit("chat message", username, msg);
  });

  socket.on("typing", function(msg) {
    io.emit("typing", username, msg);
  });

  socket.on("not-typing", function(){
    io.emit("not-typing");
  });


  socket.on('disconnect', function(){
    io.emit("disconnected", username);
  });

});

var port = 3000;
http.listen(port, function() {
  console.log("App listening on port " + port);
});
