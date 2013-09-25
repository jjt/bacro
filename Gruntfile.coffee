module.exports = (grunt) ->
  # Path to bower module
  #   ex. bower 'pure' == 'public/bower_components/pure'
  bower = (str) ->
    "public/bower_components/#{str}"

  grunt.initConfig
    # Pure is great, but I want to import the css files in scss files
    # So this takes the copy from Bower and makes *.scss files from them
    copy:
      pure:
        files: [
          expand:true
          cwd: bower 'pure-built/'
          src: ['*.css']
          dest: 'scss/pure/'
          ext: '.scss'
          rename: (dest, src) ->
            "#{dest}_#{src}"
        ]

    compass:
      options:
        importPath: ['public/bower_components']
        require: 'sass-css-importer'
      dev:
        options:
          require: 'sass-css-importer'
          sassDir: 'scss'
          cssDir: 'public/css'

    express:
      dev:
        options:
          script: 'app.coffee'
          cmd: 'coffee'
    
    watch:
      options:
        livereload: true
      express:
        files: ['**/*.coffee']
        tasks: ['express:dev']
        options:
          nospawn: true
      scss:
        files: ['scss/*.scss']
        tasks: ['compass']
        options:
          livereload: false
      css:
        files: ['public/css/*.css']
      jade:
        files: ['views/**/*.jade']

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask 'fira', 'Creates a _fira.scss file with corrected font paths', () ->
    firacss = grunt.file.read bower 'fira/fira.css'
    output = firacss.replace /url\('/g, "url('/bower_components/fira/"
    grunt.file.write bower('fira/_fira.scss'), output
    #grunt.task.run 'copy:fira'

  grunt.registerTask 'server', ['express:dev', 'watch']
