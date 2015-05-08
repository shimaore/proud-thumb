@config = (config) ->

  config.coffee =
    couchapp:
      files:
        'dist/couchapp.js': 'src/couchapp.coffee.md'

  config.couchapp =
    main:
      db: (require './local/install').db ? 'http://localhost:5984/tools'
      app: 'dist/couchapp.js'

  config.clean.couchapp = ['dist/couchapp.js']

@grunt = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-couchapp'

  grunt.registerTask 'build:couchapp', 'clean:couchapp coffee:couchapp couchapp'.split ' '
