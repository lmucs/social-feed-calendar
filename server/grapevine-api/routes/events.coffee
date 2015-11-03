pgClient = require '../../../database/pg-client'

events =
  create: (req, res) ->
    # TODO
    # eventsInsertion =
    #   text: 'INSERT INTO events (title, time_processed, location, start_time, end_time, repeats_weekly, tags, url, post, feed_id) VALUES '
    #   values: []
    # events = req.body?.events
    # for eventToAdd in events
    #   eventsInsertion.text += '($1, $2, $3, $4, $5, $6, $7, $8, $9, $10),'
    #   eventsInsertion.values.push [eventToAdd.title,
    #                                eventToAdd.timeProcessed,
    #                                eventToAdd.location,
    #                                eventToAdd.startTime,
    #                                eventToAdd.endTime,
    #                                eventToAdd.repeatsWeekly,
    #                                eventToAdd.tags,
    #                                eventToAdd.url,
    #                                eventToAdd.post,
    #                                eventToAdd.feedID]

module.exports = events
