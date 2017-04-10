'use strict';

const Twitter = require('twitter');
const server = require('http').createServer();
const io = require('socket.io')(server);

io.on('connection', function(client){
  client.on('event', function(data){});
  client.on('disconnect', function(){});
});
server.listen(3000);

var connect = require('connect');
var serveStatic = require('serve-static');
connect().use(serveStatic(__dirname)).listen(8080, () => {
    console.log('Server running on 8080...');
});

const client = new Twitter({
  consumer_key: '3hTP46FlXKoTzAljHhsrid4q0',
  consumer_secret: '9icGVwruQmULbc2rQMHDi8JRplQa0s0mR8bnSJzT2oiImm028j',
  access_token_key: '820092152222982145-FXiW7ZS0v0l7s9bIenyHLac8eOisvLl',
  access_token_secret: 'UMiKv2ztaDLkSvGITRar0adeQQv4eTj0hUfrltnxpE7pH',
});

const stream = client.stream('statuses/filter', {track: 'design'});
stream.on('data', function(event) {
  io.emit('stella', event.text); 
  // broadcast(name, content)
});

stream.on('error', function(error) {
  console.log(error);
});
