pgClient = require '../../../database/pg-client'

events =
  create: (req, res) ->
    eventsInsertion =
      text: 'INSERT INTO events (is_all_day, time_processed, start_time, end_time, processed_info, url, post, feed_id, tags, location, title) VALUES '
      values: []
    events = req.body.events
    return res.status(400).json 'message' : 'list of events required' unless events
    count = 1
    for eventToAdd in events
      eventsInsertion.text += "($#{count++},
                                $#{count++},
                                $#{count++},
                                $#{count++},
                                $#{count++},
                                $#{count++},
                                $#{count++},
                                $#{count++},
                                $#{count++},
                                $#{count++},
                                $#{count++}),"
      Array::push.apply eventsInsertion.values, [(eventToAdd.isAllDay or false),
                                                 (eventToAdd.timeProcessed or (new Date).getTime()),
                                                 (eventToAdd.startTime or null),
                                                 (eventToAdd.endTime or null),
                                                 (eventToAdd.chronosOutput or null),
                                                 (eventToAdd.url or null),
                                                 (eventToAdd.post or null),
                                                 (eventToAdd.feedID or 1)
                                                 ("{#{((t or '_') for t in (eventToAdd.tags or [])).join(',')}}")
                                                 ("{#{((loc or '_') for loc in (eventToAdd.location or [])).join(',')}}")
                                                 (eventToAdd.title or null)
                                               ]
    eventsInsertion.text = (eventsInsertion.text)[0...eventsInsertion.text.length-1]
    if eventsInsertion.values.length > 0
      pgClient.query eventsInsertion, (err) ->
        return res.status(400).send 'message': err.detail if err
        res.status(201).send 'message' : 'successfully added events'
    else
      res.status(201).send 'message' : 'no new events created'


module.exports = events