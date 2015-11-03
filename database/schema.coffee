# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

pg       = require 'pg'
pgClient = new pg.Client process.env.DB_CONNECT_STRING
pgClient.connect()

pgClient.register = (callback) ->
  query = pgClient.query '
    CREATE TABLE IF NOT EXISTS feeds(
      feed_id SERIAL PRIMARY KEY,
      feed_name text,
      source_name text,
      UNIQUE (feed_name, source_name));

    CREATE TABLE IF NOT EXISTS events(
      event_id SERIAL PRIMARY KEY,
      title text,
      time_processed integer,
      location text,
      start_time integer,
      end_time integer,
      repeats_weekly boolean,
      tags text[],
      url text,
      post text,
      feed_id SERIAL REFERENCES feeds);

    CREATE TABLE IF NOT EXISTS users(
      user_id SERIAL PRIMARY KEY,
      username text UNIQUE,
      password text,
      role text);

    CREATE TABLE IF NOT EXISTS user_follows_feed(
      feed_id int REFERENCES feeds ON DELETE CASCADE,
      user_id int REFERENCES users,
      PRIMARY KEY (feed_id, user_id));'
  query.on 'end', ->
    callback()

pgClient.clean = (callback) ->
  query = pgClient.query '
    DELETE FROM user_follows_feed;
    DELETE FROM users;
    DELETE FROM events;
    DELETE FROM feeds;'
  query.on 'end', ->
    callback()

module.exports = pgClient
