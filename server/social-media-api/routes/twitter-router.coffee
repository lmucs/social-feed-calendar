express        = require 'express'
request        = require 'request'
twitterRouter  = express.Router()

twitterAPIHost = 'https://api.twitter.com/1.1'
tweetlimit     = 100

oauth =
  consumer_key:     process.env.TWITTER_CONSUMER_KEY
  consumer_secret:  process.env.TWITTER_CONSUMER_SECRET
  token:            process.env.TWITTER_TOKEN
  token_secret:     process.env.TWITTER_TOKEN_SECRET

twitterRouter.get '/posts/:screenName/:sinceID?', (req, res) ->
  url = "#{twitterAPIHost}/" +
        "statuses/user_timeline.json" +
        "?screen_name=#{req.params.screenName}" +
        "&count=#{tweetlimit}"
  url += "&since_id#{req.params.sinceID}" if req.params.sinceID

  request.get {url, oauth}, (error, response, body) ->
    parsedBody = JSON.parse body
    if parsedBody.errors?.length > 0
      return res.status(400).json parsedBody
    res.send body

twitterRouter.get '/lists/:listID/:sinceID?', (req, res) ->
  console.log 'twitter api was called'
  url = "#{twitterAPIHost}/" +
        "lists/statuses.json" +
        "?include_rts=0" +
        "&list_id=#{req.params.listID}" +
        "&count=#{req.params.tweetLimit}"
  url += "&since_id=#{req.params.sinceID}" if req.params.sinceID

  request.get {url, oauth}, (error, response, body) ->
    parsedBody = JSON.parse body
    if parsedBody.errors?.length > 0
      return res.status(400).json parsedBody
    res.send body

module.exports = twitterRouter