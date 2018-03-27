
// var express = require('express')
// var path = require('path')
// var open = require('open')

import express from 'express'
import path from 'path'
import open from 'open'

const port = 3000
const app = express()

app.get('/', function(req, res){

    res.sendFile(path.join(__dirname, '../dist/index.html'))

})

app.listen(port, function(err) {
    if(err) {
        console.log(err)
    } else {
        console.log('Listening at http://localhost:' + port)
        open('http://localhost:' + port)
    }
})
