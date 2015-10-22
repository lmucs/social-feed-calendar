jwt = require 'jwt-simple'
# retrieveUser = require('../routes/users').retrieveUser

module.exports = (req, res, next) ->
  token = req.body?.access_token or
          req.query?.access_token or
          req.headers['x-access-token']

  key = req.body?.x_key or
        req.query?.x_key or
        req.headers['x-key']

  return res.status(401).json 'message': 'invalid token or key' unless token or key

  try
    decoded = jwt.decode token, require('../config/secret')()
    return res.status(400).json 'message': 'access token has expired.' if decoded.exp <= Date.now()
    # Authorize the user to see if they/he can access our resources
    # retrieveUser key
    dbUser =
      role: 'admin'
      username: 'rachel'
    if dbUser
      if req.url.indexOf 'admin' >= 0 and dbUser.role is 'admin' or
         req.url.indexOf 'admin' < 0
        next()
      else
        res.status(403).json 'message': 'not authorized'
    else
      res.status(401).json 'message': 'invalid user'
  catch err
    res.status(500).json 'message': 'bad request', 'error': err

