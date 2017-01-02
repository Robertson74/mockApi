var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser());

app.get('/test', function (req, res) { res.send({ "test123" : "as" }); })


var server = app.listen(3001, function () {

    var host = server.address().address
    var port = server.address().port

    console.log("Example app listening at http://%s:%s", host, port)
})
