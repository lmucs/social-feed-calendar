jwt = require 'jwt-simple'
auth = 
  login: (req, res) ->
    dbUser = auth.validate req.body.username, req.body.password
    if dbUser
      res.json generateToken dbUser
    else 
      res.status(401).json 'message': 'Invalid credentials'

  validate: (username, password) ->
    # spoofing the DB response for simplicity
    return {} unless username and password
    dbUser = 
      role: 'admin'
      username: 'rachel'
    dbUser

  validateUser: (username) ->
    # spoofing the DB response for simplicity
    dbUser = 
      role: 'admin'
      username: 'rachel'
    dbUser

generateToken = (user) ->
  expires = expiresIn(7) 
  token = jwt.encode { exp: expires }, require('../config/secret')()
  {token}

expiresIn = (numDays) ->  
  dateObj = new Date
  dateObj.setDate dateObj.getDate() + numDays

module.exports = auth