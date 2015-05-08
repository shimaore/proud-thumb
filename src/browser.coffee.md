Browser main
============

    pkg = require '../package.json'
    cfg = require '../local/config.json'

    fun = (x) -> "(#{x})"

    base = "#{window.location.protocol}//#{window.location.host}"
    db_path = config.db_path ? "#{base}/#{window.location.pathname.split('/')[1]}"

Tools

    ###
    $ = require 'component-dom'
    Promise = require 'bluebird'
    async = require 'async'
    assert = require 'assert'
    teacup = require 'teacup'
    teacup.use require 'teacup-camel-to-kebab'
    ###

Request

    ###
    request = (require 'superagent-as-promised') require 'superagent'
    ###

PouchDB

    ###
    PouchDB = require 'pouchdb'
    db = new PouchDB db_path
    ###

Socket.IO

    ###
    io = require 'socket.io-client'
    socket = io config.io ? base
    ###

Ampersand

    ###
    app = require 'ampersand-app'
    Router = require 'ampersand-router'
    module.exports = Router.extend
      routes:
        '': 'home'
        '(*path)': 'catchAll'

      home: ->
        app.trigger 'page', new HomePage
          model: app.me

      catchAll: ->
        @redirectTo ''
    ###
