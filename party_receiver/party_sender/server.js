var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var http = require('http');
const osc = require('osc-min'),
    dgram = require('dgram');
const remote = '127.0.0.1';
const port = 12000;

let server = dgram.createSocket('udp4', function(msg, rinfo) {
  try {
    let buf = osc.fromBuffer(msg);
    console.log(buf);
  } catch (err) {
    console.log('Could not decode OSC message');
  }
});
// server.bind(port);

// serve files from the public directory
app.use(express.static('public'));

// configure body-parser for express
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

// serve the homepage
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html');
});

app.post('/submit', (req, res) => {
  let msg = req.body.textbox;
  var buf = osc.toBuffer({
    oscType: 'message',
    address: '/input',
    args: msg
  });
  server.send(buf, 0, buf.length, port, remote);
  res.end();
});

// start the express web server listening on 1111
app.listen(1111, () => {
  console.log('listening on 1111');
});
