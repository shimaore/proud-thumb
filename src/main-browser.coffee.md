Browser main
============

    component = require '../dist/component'
    $ = component 'component-dom'

    pkg = require '../package.json'
    version = "#{pkg.name} version #{pkg.version}"

    page = require 'page'
    teacup = require 'teacup'

    ###
    pouchdb = require 'pouchdb'
    request = require 'superagent'

    base = "#{window.location.protocol}//#{window.location.host}"
    db_path = "#{base}/#{window.location.pathname.split('/')[1]}"
    db = new pouchdb db_path
    ###

    page '/index.html', ->
      ($ '#content').html teacup.render ->
        div 'Hello world'

    page_dir = window.location.pathname.split '/'
    page_base = page_dir[0..page_dir.length-2].join '/'
    page.base page_base
    page()
