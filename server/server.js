var express = require('express');
var _ = require('underscore');
var linq = require('linq');

const app = express()

const ingredients = {
  "sammies": "fun"
}

app.get('/', function (req, res) {
  res.send('Welcome!');
});

app.get('/ingredients', function (req, res) {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.write(JSON.stringify(ingredients));
  res.end();
});

app.listen(8000);
