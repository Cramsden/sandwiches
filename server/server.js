var express = require('express');
var _ = require('underscore');
var linq = require('linq');
var fs = require ('fs');

const app = express()

app.get('/', function (req, res) {
  res.send('Welcome!');
});

app.get('/ingredients', function (req, res) {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  fs.readFile(__dirname + '/sammy_seeds.json', function (err, data) {
    if (err) {
      throw err
    }
    res.write(data.toString())
    res.end();
  });
});

app.listen(8000);
