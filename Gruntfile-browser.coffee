@config = (config) ->

  config.copy ?= {}
  config.copy.test =
    expand: true
    cwd: 'dist/'
    src: ['*.js']
    dest: 'test/'

@grunt = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-copy'

  fs = require 'fs'
  grunt.registerTask 'test-build-html', 'Build HTML for test.', ->
    html = require 'test/index.coffee'
    fs.writeFileSync 'test/index.html', html

  grunt.registerTask 'default', 'clean:dist shell:component browserify uglify:dist'.split ' '
  grunt.registerTask 'test', 'default clean:test copy:test test-build-html'.split ' '
