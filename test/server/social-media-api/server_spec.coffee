should   = require 'should'
assert   = require 'assert'
request  = require 'supertest'
sinon    = require 'sinon'

describe 'Social Media API', ->

  before ->
    @app = require '../../../server/social-media-api/server'

  after ->
    @app.close()

  # TODO: possibly split this up into spec for FB router and spec for Twtter router?
  context 'when a valid route is used', ->

    it 'responds with a 200', (done) ->
      request 'http://localhost:3000'
        .get '/facebook/posts/LMUStudentHousing'
        .end (err, res) ->
          throw err if err
          (res.status).should.be.eql 200
          done()

    context 'when no timestamp is provided', ->
      it 'should respond with the last 100 posts by default', (done) ->
        request 'http://localhost:3000'
          .get '/facebook/posts/LMUStudentHousing'
          .end (err, res) ->
            throw err if err
            posts = (JSON.parse res.text).data
            (posts.length).should.be.eql 100
            done()

    context 'when a timestamp (in seconds) is provided', ->
      it 'should only respond with posts
          since the provided timestamp', (done) ->
        timestampFromOneWeekAgo = Math.round((Date.now() - (1000*60*60*24*7))/1000)
        request 'http://localhost:3000'
          .get "/facebook/posts/LMUStudentHousing/#{timestampFromOneWeekAgo}"
          .end (err, res) ->
            throw err if err
            for post in (JSON.parse res.text).data
              postTimestampInMilliseconds = new Date(post.created_time).getTime()
              postTimestampInSeconds = Math.round(postTimestampInMilliseconds/1000)
              postTimestampInSeconds.should.be.greaterThan timestampFromOneWeekAgo
            done()


  context 'when an invalid route is used', ->

    context 'when the route is not prefixed with the
             name of the social media source (facebook/twitter)', ->
      it 'responds with a 404', (done) ->
        request 'http://localhost:3000'
          .get '/posts/SampleFeedName'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 404
            done()

    context 'when the route does not specify posts vs events', ->
      it 'responds with a 404', (done) ->
        request 'http://localhost:3000'
          .get '/facebook/SampleFeedName'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 404
            done()

    context 'when the route does not contain the feed name', ->
      it 'responds with a 404', (done) ->
        request 'http://localhost:3000'
          .get '/twitter/posts'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 404
            done()
