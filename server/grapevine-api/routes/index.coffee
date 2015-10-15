express  = require 'express'
auth     = require './auth'
events   = require './events'
user     = require './users'

router   = express.Router()

# Routes that can be accessed by any one
router.post '/login', auth.login

#  Routes that can be accessed only by autheticated users
router.get '/api/v1/events', events.getAll
router.get '/api/v1/events/:id', events.getOne
router.post '/api/v1/events/', events.create
router.put '/api/v1/events/:id', events.update
router.delete '/api/v1/events/:id', events.delete

# Routes that can be accessed only by authenticated & authorized users
router.get '/api/v1/admin/users', user.getAll
router.get '/api/v1/admin/user/:id', user.getOne
router.post '/api/v1/admin/user/', user.create
router.put '/api/v1/admin/user/:id', user.update
router.delete '/api/v1/admin/user/:id', user.delete

module.exports = router
