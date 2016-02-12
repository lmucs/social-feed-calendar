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
app.use logger process.env.LOGGING_LEVEL or 'dev' unless process.env.NODE_ENV is 'test'

# register routes
app.use '/facebook', facebookRouter
app.use '/twitter', twitterRouter

# If no route is matched by now, it must be a 404
app.use (req, res) ->
  res.sendStatus 404

# start the server
module.exports = app.listen 3000
