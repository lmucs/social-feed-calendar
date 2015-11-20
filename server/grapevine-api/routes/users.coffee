pgClient  = require '../../../database/pg-client'
feeds     = require './feeds'
userFeeds = require './user_feeds'

users =
  create: (req, res) ->
    unless req.body.username and req.body.password
      return res.status(400).json 'message': 'username and password required'
    insertUser req.body.username, req.body.password, (err) ->
      if err
        return res.status(400).json (
          if err.code is '23505'
          then 'message': "username #{req.body.username} already exists,
                           please choose another"
          else err
        )
      require('./tokens').create req, res

  getAllEvents: (req, res) ->
    pgClient.query
      text: 'SELECT *
             FROM events, user_follows_feed
             WHERE events.feed_id = user_follows_feed.feed_id
             AND user_follows_feed.user_id = $1
             AND events.end_time > $2',
      values: [req.params.userID, (new Date).getTime()]
    , (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

  getLatestEvents: (req, res) ->
    pgClient.query
      text: 'SELECT *
             FROM events, user_follows_feed
             WHERE events.feed_id = user_follows_feed.feed_id
             AND user_follows_feed.user_id = $1
             AND time_processed > $2
             AND events.end_time > $3',
      values: [req.params.userID, req.params.after, (new Date).getTime()]
    , (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

  followFeed: (req, res) ->
    feedName   = req.body?.feedName
    networkName = req.body?.networkName
    unless feedName and networkName
      return res.status(400)
        .json 'message': "feed name and network name (e.g. 'twitter', 'facebook') required"

    feeds.get feedName, networkName, (err, result) ->
      return res.status(400).json err if err
      feed = result.rows[0]

      # create an association between the user and the feed if the feed already
      # exists in our list of all feeds that we follow
      if feed
        userFeeds.createAssociation req.params.userID, feed.feed_id, (err) ->
          return res.status(400).json 'message' : 'user already follows feed' if err
          return res.status(201)
            .json 'message' : "successfully followed feed for userID #{req.params.userID}"

      # if the feed is not one already followed by a Grapevine user, check to see
      # that it is a valid feed to follow, add the feed to our list of all feeds to follow,
      # and then create the association between the user and feed
      else
        feeds.findInNetwork feedName, networkName, (err, response, body) ->
          if err or response.statusCode isnt 200
            return res.status(404).json
              'message': "#{networkName} does not contain feed #{feedName}"
          feeds.insert feedName, networkName, (err, result) ->
            return res.status(400).json err if err
            userFeeds.createAssociation req.params.userID, result.rows[0].feed_id, (err) ->
              return res.status(400).json 'message' : 'user already follows feed' if err
              return res.status(201)
                .json 'message' : "successfully followed feed for userID #{req.params.userID}"

  unfollowFeed: (req, res) ->
    feeds.get req.params.feedName, req.params.networkName, (err, result) ->
      return res.status(400).json err if err
      feed = result.rows[0]
      if feed
        userFeeds.deleteAssociation req.params.userID, feed.feed_id, (err) ->
          return res.status(400).json err if err
          res.status(200).json
            'message': "successfully unfollowed #{req.params.feedName}
                        for userID #{req.params.userID}"
      else
        res.status(404).json 'message': "#{req.params.feedName} does not exist"

insertUser = (username, password, callback) ->
  pgClient.query
    text: 'INSERT INTO users (username, password, role)
           VALUES ($1, crypt($2, gen_salt(\'md5\')), $3)',
    values: [username, password, 'user']
  , callback

module.exports = users