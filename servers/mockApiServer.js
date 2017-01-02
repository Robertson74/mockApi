var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser());
app.set('port', 3050);

app.get('/anotherTest', function (req, res) { res.send({'test2' : 'a test'}); })
app.get('/test', function (req, res) { res.send('1'); })
app.get('/isItWorking', function (req, res) { res.send("Mock API Server seems to be working..."); })


var server = app.listen(app.get('port'), function () {
  var host = server.address().address
  var port = server.address().port
  console.log("Example app listening at http://%s:%s", host, port)
})
