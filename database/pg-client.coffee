pg       = require 'pg'
pgClient = new pg.Client process.env.DATABASE_URL

pgClient.connect()

module.exports = pgClient

