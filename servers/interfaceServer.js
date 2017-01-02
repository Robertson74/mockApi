const child_process = require('child_process');
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser());

app.get('/activeroutes', function (req, res) {
  fs = require('fs');
  fs.readFile('data/activeRoutes.txt', 'utf8' , function (err, routes) {
    if (err) {
      return console.log(err);
    }
    if (routes) {
      res.send(routes);
    } else {
      res.send('No active routes');
    }
  })
})

app.post('/resetServer', function (req, res) {
  child_process.execSync("bash scripts/resetServer.sh");
  res.send("Server Reset Successful"); 
})

app.post('/createRoute', function (req, res) {
  if(!req.body.sedCommand){
    res.status(400).send('No \"sedCommand\" in body');
  }
  console.log(req.body.sedCommand);
  child_process.execSync("bash scripts/createRoute.sh \""+req.body.sedCommand+"\"");
  console.log('test');
  res.send("Server Reset Successful"); 
})

app.get('/isItWorking', function (req, res) { res.send("Interface Server seems to be working..."); })

var server = app.listen(3059, function () {
    var host = server.address().address
    var port = server.address().port
    console.log("Example app listening at http://%s:%s", host, port)
})
