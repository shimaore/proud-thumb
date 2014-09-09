module.exports = (grunt) ->

  pkg = grunt.file.readJSON 'package.json'

  build = require "./Gruntfile-#{pkg.build}"

  config =
    pkg: pkg

    shell:
      component:
        command: 'component install -d && component build -d -o dist -n component -s undefined'

    browserify:
      dist:
        options:
          transform: ['coffeeify','debowerify','decomponentify', 'deamdify', 'deglobalify', 'rfileify', 'rfolderify']
        files:
          'dist/<%= pkg.name %>.js': 'src/main-<%= pkg.build %>.coffee.md'

    clean:
      dist: ['lib/', 'dist/']
      modules: ['node_modules/', 'bower_components/', 'components/']
      test: ['test/*.js','test/*.html']

    uglify:
      dist:
        files:
          'dist/<%= pkg.name %>.min.js': 'dist/<%= pkg.name %>.js'

    watch:
      dist:
        files: 'src/*.coffee.md'
        tasks: ['browserify','copy:test','notify:watch']

    notify:
      watch:
        options:
          title: 'Task completed'
          message: 'Build is complete.'

  build.config config

  grunt.initConfig config
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-notify'
  build.grunt grunt
