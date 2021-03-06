'use strict'

mountFolder = (connect, dir) ->
    connect.static require('path').resolve(dir)

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig

    # You can't run the docco task alone, coffeFiles & sassFiles don't chain.
    # You have to call them separatly.
    docco:<% if (CoffeeScript) { %>
      coffeeFiles:
        files:
          src: ['js/src/*.coffee']
        options:
          output: 'docs/coffee/annotated-source'
          css: 'docs/assets/custom.css'
<% } else { %>
      jsFiles:
        files:
          src: ['js/*.js']
        options:
          output: 'docs/js/annotated-source'
          css: 'docs/assets/custom.css'
<% } %>
      sassFiles:
        files:
          src: ['css/src/*.scss']
        options:
          output: 'docs/sass/annotated-source'
          css: 'docs/assets/custom.css'
<% if (CoffeeScript) { %>
    coffee:
      build:
        options:
          sourceMap: true
        expand: true
        flatten: true
        cwd: 'js/src'
        src: ['*.coffee']
        dest: 'js'
        ext: '.js'
<% } %>
    sass:
      build:
        options:
          sourcemap: true
          style: "compact"
          precision: 20
          lineNumbers: true
        files:
          'css/main.css': 'css/src/styles.scss'
          'css/ie.css': 'css/src/ie.scss'

    autoprefixer:
      build:
        browsers: ["last 3 version", "ie 8", "ie 7"]
        src: 'css/main.css'
<% if (environment == "scratch") { %>
    connect:
      all:
        options:
          hostname: grunt.option('host') || "0.0.0.0"
          port: grunt.option('port') || 0
          livereload: grunt.option('liveport') || 35729

    open:
      all:
        path: 'http://<%%= connect.all.options.hostname%>:<%%= connect.all.options.port%>/'
<% } %>
    watch:
      options:
        livereload:
          port: '<%%= connect.all.options.livereload%>'

      html:
        files:[
          '*.html'
          '**/*.html'
        ]

      sass:
        files:'css/src/*.scss'
        tasks: [
          'sass:build',
          'autoprefixer:build'
          'docco:sassFiles'
        ]
<% if (environment == "typo3") { %>
      typoscript:
        files: [
          '../typoscript/**/*.ts'
          '../ext_*.txt'
        ]
<% } %>
      images:
        files:[
          'img/**/*'
          'img/*'
        ]
<% if (CoffeeScript) { %>
      coffee:
        files: 'js/src/*.coffee'
        tasks: [
          'coffee:build'
          'docco:coffeeFiles'
        ]
<% } else { %>
      js:
        files: 'js/*.js'
        tasks: [
          'docco:jsFiles'
        ]
<% } %>

    grunt.registerTask 'default', 'serve'

    grunt.registerTask 'serve', [
      'sass:build'
      'autoprefixer:build'
<% if (CoffeeScript) { %>
      'coffee:build'
<% } %>
<% if (environment == "scratch") { %>
      'connect'
      'open'
<% } %>
      'watch'
    ]
    grunt.registerTask 'build', [
      'sass:build'
      'autoprefixer:build'
<% if (CoffeeScript) { %>
      'coffee:build'
<% } %>
    ]

