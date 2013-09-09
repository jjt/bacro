module.exports = (grunt) ->
  grunt.initConfig
    compass:
      options:
        importPath: ['public/bower_components']
      dev:
        options:
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
  grunt.registerTask 'server', ['express:dev', 'watch']
