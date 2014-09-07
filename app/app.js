var express = require('express');
var sh = require('execSync');
var logger = require('morgan');
var exec = require('child_process').exec;

var MongoClient = require('mongodb').MongoClient;

MongoClient.connect('mongodb://127.0.0.1:27017/test', function(err, db) {
    if(err) throw err;

    var collection = db.collection('test_insert');
    collection.insert({a:2}, function(err, docs) {

      collection.count(function(err, count) {
        console.log(format("count = %s", count));
      });

      // Locate all the entries using find
      collection.find().toArray(function(err, results) {
        console.dir(results);
        // Let's close the db
        db.close();
      });
    });
  })

var app = express();
app.use(express.static(__dirname + '/public'));
//app.use(logger);
// app.use(express.bodyParser());



app.get('/band_info', function(req, res){
    console.log(req.query);
    var band = req.query.band;
    var state = req.query.state;
//    var result = sh.exec('ruby ../main.rb "'+artist+'" "'+state+'"');
	res.send("hello world");
return;
child = exec('ruby ../main.rb "'+artist+'" "'+state+'"',
  function (error, stdout, stderr) {
    console.log('stdout: ' + stdout);
    console.log('stderr: ' + stderr);
    if (error !== null) {
      console.log('exec error: ' + error);
    }else{
	res.send(stdout);
    }
});
   // res.send(result.stdout);
});


app.listen(80);
console.log("running");
