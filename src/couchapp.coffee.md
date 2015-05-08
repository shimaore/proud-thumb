Main file for a CouchApp.
This is ran through browserify, feel free to require()!

    pkg = require '../package.json'

    ddoc =
      _id: "_design/#{pkg.name}"
      version: pkg.version
      views: {}
      validate_doc_update: (newDoc,oldDoc,userCtx) ->

Load attachments, return.

    couchapp = require 'couchapp'
    path = require 'path'
    couchapp.loadAttachments ddoc, path.join __dirname, '../dist/attachments'
    module.exports = ddoc
