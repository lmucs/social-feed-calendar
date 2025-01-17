# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

express    = require 'express'
logger     = require 'morgan'
bodyParser = require 'body-parser'
https      = require 'https'
http       = require 'http'
path       = require 'path'
fs         = require 'fs'
auth       = require './middlewares/auth'
tokens     = require './routes/tokens'
users      = require './routes/users'
feeds      = require './routes/feeds'
events     = require './routes/events'

app = express()

# set up middleware
app.use bodyParser.json()
app.use logger process.env.LOGGING_LEVEL or 'dev' unless process.env.NODE_ENV is 'test'

httpPort  = 8888
httpsPort = 443

privateKey  = fs.readFileSync path.normalize "#{__dirname}/../../certs/cs.lmu.edu.key"
certificate = fs.readFileSync path.normalize "#{__dirname}/../../certs/server.crt"
credentials = {key:privateKey, cert:certificate}

methodNotAllowed = (req, res) ->
  res.status(405).json 'message' : 'method not allowed'

# Routes that can be accessed by any one
app.post '/api/v1/users',  users.create
app.all  '/api/v1/users',  methodNotAllowed

app.post '/api/v1/tokens', tokens.create
app.all  '/api/v1/tokens', methodNotAllowed

#  Routes that can be accessed only by autheticated users
app.get    '/api/v1/users/:userID/events',                       [auth, users.getAllEvents]
app.all    '/api/v1/users/:userID/events',                       methodNotAllowed
app.get    '/api/v1/users/:userID/feeds',                        [auth, users.getAllFeeds]
app.get    '/api/v1/users/:userID/feeds',                        methodNotAllowed
app.get    '/api/v1/users/:userID/events/:after',                [auth, users.getLatestEvents]
app.all    '/api/v1/users/:userID/events/:after',                methodNotAllowed
app.post   '/api/v1/users/:userID/feeds',                        [auth, users.followFeed]
app.all    '/api/v1/users/:userID/feeds',                        methodNotAllowed
app.delete '/api/v1/users/:userID/feeds/:networkName/:feedName', [auth, users.unfollowFeed]
app.all    '/api/v1/users/:userID/feeds/:networkName/:feedName', methodNotAllowed

# Routes that can be accessed only by authenticated & authorized users
app.get  '/admin/v1/feeds',         [auth, feeds.getAll]
app.put  '/admin/v1/feeds/',        [auth, feeds.update]
app.put  '/admin/v1/feeds/:feedID', [auth, feeds.updateOne]
app.all  '/admin/v1/feeds',         methodNotAllowed
app.post '/admin/v1/events',        [auth, events.create]
app.all  '/admin/v1/events',        methodNotAllowed


# handle invalid routes
app.use (req, res) -> res.status(404).json 'message' : 'resource not found'

http.createServer(app).listen(httpPort)
https.createServer(credentials, app).listen(httpsPort)

module.exports = app.listen httpPort