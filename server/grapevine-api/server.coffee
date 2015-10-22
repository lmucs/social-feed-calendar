# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

express        = require 'express'
logger         = require 'morgan'
bodyParser     = require 'body-parser'

app = express()

# set up middleware
app.use bodyParser.json()
app.use logger process.env.LOGGING_LEVEL or 'dev'
app.all '/api/v1/*', [ require('./middlewares/validateRequest') ]

# register routes
app.use '/', require('./routes')

# If no route is matched by now, it must be a 404
app.use (req, res) ->
  res.sendStatus 404

app.listen process.env.PORT or 8000
