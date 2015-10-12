fs = require 'fs'
request = require 'request'
chrono = require 'chrono-node'

listID = '222479944/'
intervalInSeconds = 5
serverName = 'http://localhost:3000/'
twitterURL = 'twitter/lists/'
fbURL = ''

twitterProcessing = (listID, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{listID}"
  requestURL += sinceID if sinceID

  request requestURL , (err, res, body) ->

    tweets = JSON.parse body
    if err || tweets.errors?
      console.log 'there was an error in the request'
      console.log err 
      console.log tweets.errors

    for tweet in tweets
      parsedTweet = chrono.parse tweet.text
      if parsedTweet.length != 0  
        item = {id: tweet.id, text: tweet.text, feed: tweet.user.screen_name, date: tweet.created_at}
        fs.appendFile 'log2.txt', JSON.stringify(item, null, 4), (err) ->
          if err
            throw err
          console.log 'The "event" was appended to file!'
    return 

run = ->
  twitterProcessing listID
  return

run()