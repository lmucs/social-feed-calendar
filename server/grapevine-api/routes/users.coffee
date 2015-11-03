pgClient = require '../../../database/pg-client'
request  = require 'request'

users =

  getAllEvents: (req, res) ->
    pgClient.query
      text: 'SELECT *
             FROM events, user_follows_feed
             WHERE events.feed_id = user_follows_feed.feed_id
             AND user_follows_feed.user_id = $1',
      values: [req.params.userID]
    , (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

  getLatestEvents: (req, res) ->
    pgClient.query
      text: 'SELECT *
             FROM events, user_follows_feed
             WHERE events.feed_id = user_follows_feed.feed_id
             AND user_follows_feed.user_id = $1
             AND time_processed > $2',
      values: [req.params.userID, req.params.timestamp]
    , (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

  followFeed: (req, res) ->
    feedName   = req.body?.feedName
    sourceName = req.body?.sourceName
    unless feedName and sourceName
      return res.status(400).json 'message': 'feed name and source name required'

    getFeed feedName, sourceName, (err, result) ->
      return res.status(400).json err if err
      feed = result.rows[0]
      if feed
        createUserFeedAssociation req.params.userID, feed.feed_id
      else
        checkValidFeed feedName, sourceName, (err, response, body) ->
          if err or response.statusCode isnt 200
            return res.status(404).json
              'message': "#{sourceName} does not contain feed #{feedName}"
          insertFeed feedName, sourceName, (err, result) ->
            return res.status(400).json err if err
            createUserFeedAssociation req.params.userID, result.rows[0].feed_id

    createUserFeedAssociation = (userID, feedID) ->
      pgClient.query
        text: 'INSERT INTO user_follows_feed (user_id, feed_id)
               VALUES ($1, $2)',
        values: [userID, feedID]
      , (err, result) ->
        return res.status(400).json 'message': 'user already follows feed' if err
        res.status(200).json
          'message': "successfully followed feed for userID #{userID}"

  unfollowFeed: (req, res) ->
    getFeed req.params.feedName, req.params.sourceName, (err, result) ->
      return res.status(400).json err if err
      feed = result.rows[0]
      if feed
        pgClient.query
          text: 'DELETE FROM user_follows_feed
                 WHERE user_id = $1 AND feed_id = $2',
          values: [req.params.userID, feed.feed_id]
        , (err) ->
          return res.status(400).json err if err
          res.status(200).json
            'message': "successfully unfollowed #{req.params.feedName}
                        for #{req.params.userID}"
      else
        res.status(404).json 'message': "#{req.params.feedName} does not exist"

checkValidFeed = (feedName, sourceName, callback) ->
  request "https://social-media.herokuapp.com/#{sourceName}/posts/#{feedName}", callback

insertFeed = (feedName, sourceName, callback) ->
  pgClient.query
    text: 'INSERT INTO feeds (feed_name, source_name)
           VALUES ($1, $2)
           RETURNING feed_id, feed_name',
    values: [feedName, sourceName]
  , callback

getFeed = (feedName, sourceName, callback) ->
  pgClient.query
    text: 'SELECT * FROM feeds WHERE feed_name = $1 AND source_name = $2',
    values: [feedName, sourceName]
  , callback

module.exports = users