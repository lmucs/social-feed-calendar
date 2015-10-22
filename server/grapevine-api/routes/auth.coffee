jwt      = require 'jwt-simple'
pgClient = require '../pg-client'

auth =
  register: (req, res) ->
    insertUser req.body.username, req.body.password, (err) ->
      if err
        return res.status(400).json (
          if err.code is '23505'
          then 'message': "username #{req.body.username} already exists,
                           please choose another"
          else err
        )
      auth.login req, res

  login: (req, res) ->
    getUser req.body.username, req.body.password, (err, user) ->
      return res.status(400).json err if err
      return res.status(401).json 'message': 'invalid credentials' unless user
      token = generateToken()
      res.status(200).json {token, userID: user.user_id}

insertUser = (username, password, callback) ->
  pgClient.query
    text: 'INSERT INTO users (username, password, role) VALUES ($1, $2, $3)',
    values: [username, password, 'user']
  , callback

getUser = (username, password, callback) ->
  pgClient.query
    text: 'SELECT * FROM users WHERE username = $1 AND password = $2',
    values: [username, password]
  , (err, result) ->
    return callback err if err
    callback null, result.rows[0]

generateToken = ->
  expires = expiresIn(7)
  token = jwt.encode { expires }, require('../config/secret')()
  token

expiresIn = (numDays) ->
  dateObj = new Date
  dateObj.setDate dateObj.getDate() + numDays


module.exports = auth