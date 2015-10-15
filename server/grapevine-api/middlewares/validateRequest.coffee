jwt = require 'jwt-simple'
validateUser = require('../routes/auth').validateUser

module.exports = (req, res, next) ->
  token = req.body?.access_token or 
          req.query?.access_token or 
          req.headers['x-access-token']
          
  key = req.body?.x_key or 
        req.query?.x_key or 
        req.headers['x-key']

  return res.status(401).json 'message': 'Invalid token or key' unless token or key

  try
    decoded = jwt.decode token, require('../config/secret')()
    return res.status(400).json 'message': 'Access token has expired.' if decoded.exp <= Date.now()
    # Authorize the user to see if they/he can access our resources
    dbUser = validateUser key
    if dbUser
      if req.url.indexOf 'admin' >= 0 and dbUser.role is 'admin' or 
         req.url.indexOf 'admin' < 0 and req.url.indexOf '/api/v1/' >= 0
        next()
      else
        res.status(403).json 'message': 'Not Authorized'
    else
      res.status(401).json 'message': 'Invalid user'
  catch err
    res.status(500).json 'message': 'Bad Request', 'error': err
    
