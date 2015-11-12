Browser main
============

    pkg = require '../package.json'
    cfg = require '../local/config.json'

    fun = (x) -> "(#{x})"

    base = "#{window.location.protocol}//#{window.location.host}"
    db_path = cfg.db_path ? "#{base}/#{window.location.pathname.split('/')[1]}"

Tools

    Promise = require 'bluebird'
    $ = require 'component-dom'
    ###
    async = require 'async'
    assert = require 'assert'
    ###
    teacup = require 'teacup'
    teacup.use require 'teacup-camel-to-kebab'

Request

    request = (require 'superagent-as-promised') require 'superagent'

PouchDB

    ###
    PouchDB = require 'pouchdb'
    db = new PouchDB db_path
    ###

Socket.IO

    io = require 'socket.io-client'
    socket = io() # cfg.io ? base

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

    socket.on 'connect', ->
      console.log 'connect'
      Promise.resolve()
      .then ->
        zappa.share socket
      .then ->

Start `spicy-action` handshake.

        socket.emit 'join'

    socket.on 'ready', ({roles}) ->
      console.log 'ready'
      console.log roles
    socket.on 'failed', ({msg}) ->
      console.log 'failed'
      console.log msg

    template = teacup.renderable ({host,data:{state,source,destination,data}}) ->
      {div,text} = teacup
      div ->
        text "#{host}: Call from #{source} to #{destination}"
        switch state
          when 'incoming-call'
            text "."
          when 'call-attempt'
            text ", attempting to route."
          when 'immediate-response'
            text ", error (not routing)."
          when 'end'
            text ", finished, progress #{data.progress/1000}, answer: #{data.answer/1000}, billable: #{data.billable/1000}, duration: #{data.duration/1000}."

    template_ops = teacup.renderable (data) ->
      {type,host,ip,status,message} = data
      {div,text} = teacup
      div ->
        text "#{host}: "
        switch state
          when 'invalid'
            text "invalid access from #{ip}"
          when 'registrant_failure'
            text "registrant failure from #{ip} (#{status}): "
            div message
          else
            text JSON.stringify data

    socket.on 'call', (data)->
      console.log arguments
      content = template data
      $('div#content').prepend content
    socket.on 'ops', ->
      content = template_ops data
      $('div#content').prepend content
      console.log arguments

    zappa =
      channel: cfg.zappa_channel ? '__local'
      prefix: cfg.zappa_prefix ? '/zappa'
      share: (socket) ->
        request "#{zappa.prefix}/socket/#{zappa.channel}/#{socket.id}"
        .then ({body:{key}}) ->
          new Promise (resolve,reject) ->
            try
              socket.emit '__zappa_key', {key}, (ack) ->
                if ack is true
                  resolve()
                else
                  reject new Error ack.error
            catch error
              reject error
