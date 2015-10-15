mockEvents  = require './mockEvents'

events = 
  getAll: (req, res) ->
    # Spoof a DB call
    res.json mockEvents

  getOne: (req, res) ->
    # Spoof a DB call
    res.json mockEvents[1]

  create: (req, res) ->
    newEvent = req.body
    # Spoof a DB call
    mockEvents.push newEvent
    res.json newEvent

  update: (req, res) ->
    updatedEvent = req.body
    # Spoof a DB call
    mockEvents[req.params.id] = updatedEvent
    res.json updatedEvent

  delete: (req, res) ->
    # Spoof a DB call
    mockEvents.splice req.params.id, 1
    res.json true
    

module.exports = events
