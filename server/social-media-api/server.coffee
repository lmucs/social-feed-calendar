# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

express        = require 'express'
bodyParser     = require 'body-parser'
logger         = require 'morgan'
facebookRouter = require './routes/facebook-router'
twitterRouter  = require './routes/twitter-router'

app = express()

# set up middleware
app.use bodyParser.json()
app.use logger process.env.LOGGING_LEVEL or 'dev'

app.all '/*', (req, res, next) ->
  res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'
  res.header 'Access-Control-Allow-Headers', 'Content-type,Accept,X-Access-Token,X-Key'
  next()

# register routes
app.use '/facebook', facebookRouter
app.use '/twitter', twitterRouter

# If no route is matched by now, it must be a 404
app.use (req, res) ->
  res.sendStatus 404

# start the server
app.listen process.env.PORT or 3000