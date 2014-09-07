var express = require('express');
var sh = require('execSync');
var logger = require('morgan');


var app = express();
app.use(express.static(__dirname + '/public'));
app.use(logger);
// app.use(express.bodyParser());



app.get('/band_info', function(req, res){
    console.log(req.query);
    var band = req.query.band;
    var state = req.query.state;
    var result = sh.exec('ruby ../main.rb "'+artist+'" "'+state+'"');
    res.send(result.stdout);
});


app.listen(80);
console.log("running");