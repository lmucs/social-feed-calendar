should   = require 'should'
request  = require 'supertest'
sinon    = require 'sinon'

describe 'Grapevine API', ->

  before ->
    @app = require '../../../server/grapevine-api/server'
    @db  = require '../../../database/pg-client'

  beforeEach ->
    @db.query '
      DELETE FROM user_follows_feed;
      DELETE FROM users;
      DELETE FROM events;
      DELETE FROM feeds;'

  after ->
    @app.close()

  context 'when an invalid route is used', ->
    it 'responds with a 404 not found', (done) ->
      request 'http://localhost:8000'
        .get '/invalid/route'
        .end (err, res) ->
          throw err if err
          (res.status).should.be.eql 404
          (res.body.message).should.be.eql 'resource not found'
          done()

  context 'when a valid route is used', ->

    context 'when an invalid method is used for /api/v1/users', ->
      it 'responds with a 405 method not allowed', (done) ->
        request 'http://localhost:8000'
          .get '/api/v1/users'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 405
            (res.body.message).should.be.eql 'method not allowed'
            done()

    context 'when an invalid method is used for /api/v1/tokens', ->
      it 'responds with a 405 method not allowed', (done) ->
        request 'http://localhost:8000'
          .get '/api/v1/tokens'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 405
            (res.body.message).should.be.eql 'method not allowed'
            done()

    context 'when an invalid method is used for /api/v1/users/{userID}/events', ->
      it 'responds with a 405 method not allowed', (done) ->
        request 'http://localhost:8000'
          .post '/api/v1/users/1/events'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 405
            (res.body.message).should.be.eql 'method not allowed'
            done()

    context 'when an invalid method is used for /api/v1/users/{userID}/feeds', ->
      it 'responds with a 405 method not allowed', (done) ->
        request 'http://localhost:8000'
          .get '/api/v1/users/1/feeds'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 405
            (res.body.message).should.be.eql 'method not allowed'
            done()

    context 'when an invalid method is used for /api/v1/users/{userID}/feeds/{networkName}/{feedName}', ->
      it 'responds with a 405 method not allowed', (done) ->
        request 'http://localhost:8000'
          .get '/api/v1/users/1/feeds/twitter/LMUHousing'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 405
            (res.body.message).should.be.eql 'method not allowed'
            done()

    context 'when an invalid method is used for /admin/v1/feeds', ->
      it 'responds with a 405 method not allowed', (done) ->
        request 'http://localhost:8000'
          .delete '/admin/v1/feeds'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 405
            (res.body.message).should.be.eql 'method not allowed'
            done()

    context 'when an invalid method is used for /admin/v1/events', ->
      it 'responds with a 405 method not allowed', (done) ->
        request 'http://localhost:8000'
          .get '/admin/v1/events'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 405
            (res.body.message).should.be.eql 'method not allowed'
            done()

    context 'when a client POSTs to the /api/v1/users endpoint', ->

      context 'when the username or password is omitted', ->
        it 'responds with a 400 bad request', (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/users'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 400
              (res.body.message).should.be.eql 'username and password required'
              done()

      context 'when someone tries to create a user with an existing username', ->
        beforeEach (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/users'
            .send {username: 'foo', password: 'bar'}
            .end (err, res) ->
              throw err if err
              done()

        it 'responds with a 400 bad request', (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/users'
            .send {username: 'foo', password: 'baz'}
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 400
              (res.body.message).should.be.eql 'username foo already exists,
                                                please choose another'
              done()

      context 'when a valid username and password are given', ->
        it 'responds with a 201 created, an access token,
            and the user ID of the newly created user', (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/users'
            .send {username: 'foo', password: 'bar'}
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 201

              token = res.body.token
              should.exist token
              ((token.match /[a-z0-9\.\-\_]+/gi)[0]).should.be.eql token

              userID = res.body.userID
              should.exist userID

              done()

    context 'when a client POSTs to the /api/v1/tokens endpoint', ->

      context 'when the username or password are omitted', ->
        it 'responds with a 400 bad request', (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/tokens'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 400
              (res.body.message).should.be.eql 'username and password required'
              done()

      context 'when the given username/password combination
               does not exist in the database', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/tokens'
            .send {username: 'invalidUsername', password: 'invalidPassword'}
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'invalid credentials'
              done()

      context 'when a valid username/password combination is given', ->
        beforeEach (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/users'
            .send {username: 'foo', password: 'bar'}
            .end (err, res) ->
              throw err if err
              done()

        it 'responds with a 201 created,
            the newly created access token,
            and the user ID', (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/tokens'
            .send {username: 'foo', password: 'bar'}
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 201

              token = res.body.token
              should.exist token
              ((token.match /[a-z0-9\.\-\_]+/gi)[0]).should.be.eql token

              userID = res.body.userID
              should.exist userID
              done()


    context 'when a client GETs from the /api/v1/users/{userID}/events endpoint', ->

      context 'when the client omits the access token from the header', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .get '/api/v1/users/1/events'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'access token required'
              done()

      context 'when the client does not omit the access token', ->

        context 'when an invalid access token is given', ->
          it 'responds with a 401 unauthorized', (done) ->
            request 'http://localhost:8000'
              .get '/api/v1/users/1/events'
              .set 'x-access-token', 'invalid-access-token'
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 401
                (res.body.message).should.be.eql 'invalid access token'
                done()

        context 'when a valid access token is given', ->
          beforeEach (done) ->
            request 'http://localhost:8000'
              .post '/api/v1/users'
              .send {username: 'foo', password: 'bar'}
              .end (err, res) =>
                throw err if err
                @token = res.body.token
                done()

          context 'when the client tries to get events for a nonexistent user id', ->
            it 'responds with an empty array', (done) ->
              request 'http://localhost:8000'
                .get '/api/v1/users/1/events'
                .set 'x-access-token', @token
                .end (err, res) ->
                  throw err if err
                  (res.body).should.be.eql []
                  done()

          context 'when the client gets events for an existing user id', ->

            context 'when the client does not include a timestamp', ->

              it 'responds with a 200 OK and all events from the feeds the user follows', (done) ->
                @db.query 'INSERT INTO feeds (feed_id) VALUES (1);
                           INSERT INTO users (user_id) VALUES (1);
                           INSERT INTO user_follows_feed (user_id, feed_id) VALUES (1,1);'
                @db.query
                  text: 'INSERT INTO events (title, feed_id, end_time) VALUES (\'Sunset at the Bluff\', 1, $1);'
                  values: [(new Date).getTime() + 10000]

                request 'http://localhost:8000'
                  .get '/api/v1/users/1/events'
                  .set 'x-access-token', @token
                  .end (err, res) ->
                    throw err if err
                    (res.body.length).should.be.eql 1
                    userEvent = res.body[0]
                    (userEvent.user_id).should.be.eql 1
                    (userEvent.feed_id).should.be.eql 1
                    (userEvent.title).should.be.eql 'Sunset at the Bluff'
                    done()

            context 'when the client does include a timestamp', ->

              it 'responds with a 200 OK and all events that have been processed after the timestamp', (done) ->
                @db.query 'INSERT INTO feeds (feed_id) VALUES (1);
                           INSERT INTO events (title, feed_id, time_processed) VALUES (\'Sunrise at the Bluff\', 1, 123);
                           INSERT INTO events (title, feed_id, time_processed, end_time) VALUES (\'Sunset at the Bluff that already happened\', 1, 456, 0);
                           INSERT INTO users (user_id) VALUES (1);
                           INSERT INTO user_follows_feed (user_id, feed_id) VALUES (1,1);'
                @db.query
                  text: 'INSERT INTO events (title, feed_id, time_processed, end_time) VALUES (\'Upcoming Sunset at the Bluff\', 1, 456, $1);'
                  values: [(new Date).getTime() + 10000]

                request 'http://localhost:8000'
                  .get '/api/v1/users/1/events/200'
                  .set 'x-access-token', @token
                  .end (err, res) ->
                    throw err if err
                    (res.body.length).should.be.eql 1
                    userEvent = res.body[0]
                    (userEvent.user_id).should.be.eql 1
                    (userEvent.feed_id).should.be.eql 1
                    (userEvent.title).should.be.eql 'Upcoming Sunset at the Bluff'
                    done()

    context 'when a client POSTs to the /api/v1/users/{userID}/feeds endpoint', ->

      context 'when the client omits the access token from the headers', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .post '/api/v1/users/1/feeds'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'access token required'
              done()

      context 'when the client does not omit the access token', ->

        context 'when an invalid access token is given', ->
          it 'responds with a 401 unauthorized', (done) ->
            request 'http://localhost:8000'
              .post '/api/v1/users/1/feeds'
              .set 'x-access-token', 'invalid-access-token'
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 401
                (res.body.message).should.be.eql 'invalid access token'
                done()

        context 'when a valid access token is given', ->
          beforeEach (done) ->
            request 'http://localhost:8000'
              .post '/api/v1/users'
              .send {username: 'foo', password: 'bar'}
              .end (err, res) =>
                throw err if err
                @token = res.body.token
                done()

          context 'when the client omits the feed name or network name to follow', ->
            it 'responds with a 400 bad request', (done) ->
              request 'http://localhost:8000'
                .post '/api/v1/users/1/feeds'
                .set 'x-access-token', @token
                .end (err, res) ->
                  throw err if err
                  (res.status).should.be.eql 400
                  (res.body.message).should.be.eql "feed name and network name (e.g. 'twitter', 'facebook') required"
                  done()

          context 'when the client includes both the feed name or network name to follow', ->

            context 'when it is a valid feed to follow', ->

              context 'when the feed already exists in our list of all followed feeds', ->

                it 'responds with a 201 created
                    (indicating the creation of an association between the user and feed)', (done) ->
                  @db.query 'INSERT INTO users (user_id) VALUES (1);
                             INSERT INTO feeds (feed_name, network_name) VALUES (\'LMUHousing\', \'twitter\')'
                  request 'http://localhost:8000'
                    .post '/api/v1/users/1/feeds'
                    .set 'x-access-token', @token
                    .send {feedName: 'LMUHousing', networkName: 'twitter'}
                    .end (err, res) ->
                      throw err if err
                      (res.status).should.be.eql 201
                      (res.body.message).should.be.eql 'successfully followed feed for userID 1'
                      done()

              context 'when the does not already exists in our list of all followed feeds', ->

                it 'adds the feed to our list of all feeds and
                    responds with a 201 created (indicating the creation of association between the user and feed)', (done) ->
                  @db.query 'INSERT INTO users (user_id) VALUES (1);'
                  request 'http://localhost:8000'
                    .post '/api/v1/users/1/feeds'
                    .set 'x-access-token', @token
                    .send {feedName: 'LMUStudentHousing', networkName: 'facebook'}
                    .end (err, res) =>
                      throw err if err
                      (res.status).should.be.eql 201
                      (res.body.message).should.be.eql 'successfully followed feed for userID 1'
                      # the feed gets added to the list of all feeds to follow
                      @db.query 'SELECT * FROM feeds', (err, result) ->
                        (result.rows.length).should.be.eql 1
                        done()

            context 'when it is not a valid feed to follow', ->
              it 'responds with a 404 not found', (done) ->
                @db.query 'INSERT INTO users (user_id) VALUES (1);'
                request 'http://localhost:8000'
                  .post '/api/v1/users/1/feeds'
                  .set 'x-access-token', @token
                  .send {feedName: '%', networkName: 'twitter'} # twitter feeds can only contain alphanumeric characters
                  .end (err, res) ->
                    throw err if err
                    (res.status).should.be.eql 404
                    (res.body.message).should.be.eql 'twitter does not contain feed %'
                    done()

    context 'when a client DELETEs from the /api/v1/users/{userID}/feeds/{network}/{feedName} endpoint', ->

      context 'when the client omits the access token', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .delete '/api/v1/users/1/feeds/facebook/LMUHousing'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'access token required'
              done()

      context 'when the client does not omit the access token', ->

        context 'when an invalid access token is given', ->
          it 'responds with a 401 unauthorized', (done) ->
            request 'http://localhost:8000'
              .delete '/api/v1/users/1/feeds/facebook/LMUHousing'
              .set 'x-access-token', 'invalid-access-token'
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 401
                (res.body.message).should.be.eql 'invalid access token'
                done()

        context 'when a valid access token is given', ->
          beforeEach (done) ->
            request 'http://localhost:8000'
              .post '/api/v1/users'
              .send {username: 'foo', password: 'bar'}
              .end (err, res) =>
                throw err if err
                @token = res.body.token
                done()

          it 'responds with a 200 OK and deletes the association of the user with the feed', (done) ->
            @db.query 'INSERT INTO users (user_id) VALUES (1);
                       INSERT INTO feeds (feed_id, feed_name, network_name) VALUES (1, \'LMUHousing\', \'twitter\');
                       INSERT INTO user_follows_feed (feed_id, user_id) VALUES (1, 1)'
            request 'http://localhost:8000'
              .delete '/api/v1/users/1/feeds/twitter/LMUHousing'
              .set 'x-access-token', @token
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 200
                (res.body.message).should.be.eql 'successfully unfollowed LMUHousing for userID 1'
                done()


    context 'when a client GETs from the /api/v1/feeds endpoint', ->

      context 'when the client omits the access token', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .get '/admin/v1/feeds'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'access token required'
              done()

      context 'when the client does not omit the access token', ->

        context 'when an invalid access token is given', ->
          it 'responds with a 401 unauthorized', (done) ->
            request 'http://localhost:8000'
              .get '/admin/v1/feeds'
              .set 'x-access-token', 'invalid-access-token'
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 401
                (res.body.message).should.be.eql 'invalid access token'
                done()

        context 'when a valid access token is given', ->

          context 'when the user is not an admin', ->
            beforeEach (done) ->
              request 'http://localhost:8000'
                .post '/api/v1/users'
                .send {username: 'foo', password: 'bar'}
                .end (err, res) =>
                  throw err if err
                  @token = res.body.token
                  done()

            it 'responds with a 403 forbidden', (done) ->
              request 'http://localhost:8000'
                .get '/admin/v1/feeds'
                .set 'x-access-token', @token
                .end (err, res) ->
                  throw err if err
                  (res.status).should.be.eql 403
                  done()

          context 'when the user is an admin', ->
            beforeEach (done) ->
              @db.query 'INSERT INTO users (user_id, username, password, role)
                         VALUES (1, \'foo\', crypt(\'bar\', gen_salt(\'md5\')), \'admin\');'
              request 'http://localhost:8000'
                .post '/api/v1/tokens'
                .send {username: 'foo', password: 'bar'}
                .end (err, res) =>
                  throw err if err
                  @token = res.body.token
                  done()

              it 'responds with a 200 OK and all feeds Grapevine currently pulls from', (done) ->
                @db.query 'INSERT INTO feeds (feed_name, network_name) VALUES (\'LMUHousing\', \'facebook\')'
                request 'http://localhost:8000'
                  .get '/admin/v1/feeds'
                  .set 'x-access-token', @token
                  .end (err, res) ->
                    throw err if err
                    (res.status).should.be.eql 200
                    (res.body).should.be.eql
                      facebook: ['LMUHousing']
                      twitter: process.env.TWITTER_LIST_ID
                      lastPulled: '0'
                    done()

    context 'when a client PUTs to the /admin/v1/feeds endpoint', ->

      context 'when the client omits the access token', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .put '/admin/v1/feeds'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'access token required'
              done()

      context 'when the client does not omit the access token', ->

        context 'when an invalid access token is given', ->
          it 'responds with a 401 unauthorized', (done) ->
            request 'http://localhost:8000'
              .put '/admin/v1/feeds'
              .set 'x-access-token', 'invalid-access-token'
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 401
                (res.body.message).should.be.eql 'invalid access token'
                done()

        context 'when a valid access token is given', ->

          context 'when the user is not an admin', ->
            beforeEach (done) ->
              request 'http://localhost:8000'
                .post '/api/v1/users'
                .send {username: 'foo', password: 'bar'}
                .end (err, res) =>
                  throw err if err
                  @token = res.body.token
                  done()

            it 'responds with a 403 forbidden', (done) ->
              request 'http://localhost:8000'
                .put '/admin/v1/feeds'
                .set 'x-access-token', @token
                .end (err, res) ->
                  throw err if err
                  (res.status).should.be.eql 403
                  done()

          context 'when the user is an admin', ->
            beforeEach (done) ->
              @db.query 'INSERT INTO users (user_id, username, password, role)
                         VALUES (1, \'foo\', crypt(\'bar\', gen_salt(\'md5\')), \'admin\');'
              request 'http://localhost:8000'
                .post '/api/v1/tokens'
                .send {username: 'foo', password: 'bar'}
                .end (err, res) =>
                  throw err if err
                  @token = res.body.token
                  done()

            context 'when a timestamp indicating the new last time when posts were processed is not provided', ->
              it 'responds with a 400 bad request', (done) ->
                request 'http://localhost:8000'
                  .put '/admin/v1/feeds'
                  .set 'x-access-token', @token
                  .end (err, res) ->
                    throw err if err
                    (res.status).should.be.eql 400
                    (res.body.message).should.be.eql 'lastPulled timestamp required'
                    done()


            context 'when a timestamp indicating the new last time when posts were processed is provided', ->
              it 'updates the timestamp of when all feeds were last pulled', (done) ->
                @db.query 'INSERT INTO feeds (feed_id, last_pulled) VALUES (1,0);
                           INSERT INTO feeds (feed_id, last_pulled) VALUES (2,0);'
                request 'http://localhost:8000'
                  .put '/admin/v1/feeds'
                  .send {lastPulled: 123}
                  .set 'x-access-token', @token
                  .end (err, res) =>
                    throw err if err
                    (res.status).should.be.eql 200
                    (res.body.message).should.be.eql 'successfully updated time last pulled'
                    @db.query 'SELECT last_pulled FROM feeds', (err, result) ->
                      throw err if err
                      ((result.rows).every (row) -> row.last_pulled is '123').should.be.true
                      done()

    context 'when a client POSTs to the /admin/v1/events endpoint', ->

      context 'when the client omits the access token from the header', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .post '/admin/v1/events'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'access token required'
              done()


   context 'when the client does not omit the access token', ->

        context 'when an invalid access token is given', ->
          it 'responds with a 401 unauthorized', (done) ->
            request 'http://localhost:8000'
              .put '/admin/v1/feeds'
              .set 'x-access-token', 'invalid-access-token'
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 401
                (res.body.message).should.be.eql 'invalid access token'
                done()

        context 'when a valid access token is given', ->

          context 'when the user is not an admin', ->
            it 'responds with a 403 forbidden', (done) ->
              @db.query 'INSERT INTO users (user_id, username, password, role)
                         VALUES (1, \'foo\', crypt(\'bar\', gen_salt(\'md5\')), \'user\');'
              request 'http://localhost:8000'
                .post '/api/v1/tokens'
                .send {username: 'foo', password: 'bar'}
                .end (err, res) ->
                  throw err if err
                  request 'http://localhost:8000'
                    .post '/admin/v1/events'
                    .set 'x-access-token', res.body.token
                    .end (err, res) ->
                      throw err if err
                      (res.status).should.be.eql 403
                      done()

          context 'when the user is an admin', ->
            beforeEach (done) ->
              @db.query 'INSERT INTO users (user_id, username, password, role)
                         VALUES (1, \'foo\', crypt(\'bar\', gen_salt(\'md5\')), \'admin\');'
              request 'http://localhost:8000'
                .post '/api/v1/tokens'
                .send {username: 'foo', password: 'bar'}
                .end (err, res) =>
                  throw err if err
                  @token = res.body.token
                  done()

            context 'an array of events is not given in the request body', ->
              it 'responds with a 400 bad request', (done) ->
                request 'http://localhost:8000'
                  .post '/admin/v1/events'
                  .set 'x-access-token', @token
                  .end (err, res) ->
                    throw err if err
                    (res.status).should.be.eql 400
                    (res.body.message).should.be.eql 'list of events required'
                    done()

            context 'an array of events is given in the request body', ->
              it 'responds with a 200 ok and adds all of the given events to the data store', (done) ->
                @db.query 'INSERT INTO feeds (feed_id) VALUES (1);'
                request 'http://localhost:8000'
                  .post '/admin/v1/events'
                  .set 'x-access-token', @token
                  .send {events: [{'title': 'blah', 'feedID': 1}]}
                  .end (err, res) =>
                    throw err if err
                    (res.status).should.be.eql 200
                    (res.body.message).should.be.eql 'successfully added events'
                    @db.query 'SELECT * FROM events', (err, result) ->
                      throw err if err
                      (result.rows.length).should.be.eql 1
                      (result.rows[0].title).should.be.eql 'blah'
                      done()