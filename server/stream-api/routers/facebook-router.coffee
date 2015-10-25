express        = require 'express'
request        = require 'request'
facebookRouter = express.Router()

APIHost        = 'https://graph.facebook.com'
feedLimit      = 100

facebookRouter.get '/:feedType/:pageName/:timestamp?', (req, res) ->

  getPageID = (next) ->
    pageIDEndpoint = "#{APIHost}/" +
                      "#{req.params.pageName}/" +
                      "?access_token=#{process.env.FB_TOKEN}"
    request pageIDEndpoint, (err, response, body) ->
      parsedBody = JSON.parse body
      return res.sendStatus response.statusCode if parsedBody.error
      next parsedBody.id

  getFeedFromID = (id) ->
    feedEndpoint = "#{APIHost}/#{id}/" +
                   "#{req.params.feedType}" +
                   "?access_token=#{process.env.FB_TOKEN}" +
                   "&limit=#{feedLimit}"
    feedEndpoint += "&since=#{req.params.timestamp}" if req.params.timestamp
    request feedEndpoint, (err, response, body) ->
      return res.sendStatus response.statusCode if (JSON.parse body).error
      res.send JSON.parse body
      body

  getPageID getFeedFromID


module.exports = facebookRouter