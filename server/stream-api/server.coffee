# load environment variables
require('dotenv').load()

express        = require 'express'
bodyParser     = require 'body-parser'
morgan         = require 'morgan'
facebookRouter = require './routers/facebook-router'
twitterRouter  = require './routers/twitter-router'

app = express()

# set up middleware
app.use bodyParser.json()
app.use morgan 'common', {}

# register routes
app.use '/facebook', facebookRouter
app.use '/twitter', twitterRouter

# start the server
port = process.env.PORT or 3000
app.listen port
console.log "Listening on port #{port}"