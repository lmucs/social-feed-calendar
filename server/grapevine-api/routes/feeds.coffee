pgClient = require '../../../database/pg-client'

feeds =
  getAll: (req, res) ->
    pgClient.query 'SELECT * FROM feeds', (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

module.exports = feeds
