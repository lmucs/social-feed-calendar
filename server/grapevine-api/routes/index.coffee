express  = require 'express'
auth     = require './auth'
users    = require './users'
events   = require './events'
feeds    = require './feeds'

router   = express.Router()

# Routes that can be accessed by any one
router.post '/register', auth.register
router.post '/login',    auth.login

#  Routes that can be accessed only by autheticated users
router.get    '/api/v1/feeds',                                     feeds.getAll
router.get    '/api/v1/users/:userID/events',                      users.getAllEvents
router.get    '/api/v1/users/:userID/events/:timestamp',           users.getLatestEvents
router.post   '/api/v1/users/:userID/feeds',                       users.followFeed
router.delete '/api/v1/users/:userID/feeds/:sourceName/:feedName', users.unfollowFeed

# Routes that can be accessed only by authenticated & authorized users
# TODO: router.post '/api/v1/admin/events', events.create

module.exports = router
