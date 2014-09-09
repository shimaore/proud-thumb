@config = (config) ->

  config.couchapp =
    main:
      db: 'http://localhost:5984/main'
      app: 'dist/<%= pkg.name %>.js'

@grunt = (grunt) ->

  grunt.loadNpmTasks 'grunt-couchapp'

  grunt.registerTask 'default', 'clean:dist browserify couchapp'.split ' '
