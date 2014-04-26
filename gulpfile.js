'use strict';
// generated on 2014-04-23 using generator-gulp-webapp 0.0.8

var gulp = require('gulp');
var browserify = require('browserify');

var config = {
  connectDomain: 'http://bacro.node',
  connectPort: 3000,
  liveReloadPort: 35729 
}

// load plugins
var $ = require('gulp-load-plugins')();

gulp.task('styles', function () {
  return gulp.src('public/styles/main.scss')
    .pipe($.sass({
    }))
    .pipe($.autoprefixer('last 1 version'))
    .pipe(gulp.dest('.public/styles'))
    .pipe($.size());
});

gulp.task('coffee', function() {
  return gulp.src('public/script/**/*.coffee')
    .pipe($.coffee({bare: true})).on('error', $.util.log)
    .pipe(gulp.dest('.public/script'));
});

gulp.task('html', ['styles'], function () {
  var jsFilter = $.filter('**/*.js');
  var cssFilter = $.filter('**/*.css');

  return gulp.src('views/*.jade')
    .pipe($.useref.assets())
    .pipe(jsFilter)
    .pipe($.uglify())
    .pipe(jsFilter.restore())
    .pipe(cssFilter)
    .pipe($.csso())
    .pipe(cssFilter.restore())
    .pipe($.useref.restore())
    .pipe($.useref())
    .pipe(gulp.dest('dist'))
    .pipe($.size());
});

gulp.task('images', function () {
  return gulp.src('public/images/**/*')
    .pipe($.cache($.imagemin({
      optimizationLevel: 3,
      progressive: true,
      interlaced: true
    })))
    .pipe(gulp.dest('dist/images'))
    .pipe($.size());
});

gulp.task('fonts', function () {
  return $.bowerFiles()
    .pipe($.filter('**/*.{eot,svg,ttf,woff}'))
    .pipe($.flatten())
    .pipe(gulp.dest('dist/fonts'))
    .pipe($.size());
});

gulp.task('clean', function () {
  return gulp.src(['.public', 'dist'], { read: false }).pipe($.clean());
});

gulp.task('build', ['html', 'images', 'fonts']);

gulp.task('connect', function () {
  var connect = require('connect');
  var app = connect()
    .use(require('connect-livereload')({ port: config.liveReloadPort }))
    .use(connect.static('public'))
    .use(connect.static('.public'))
    .use(connect.directory('public'));

  require('http').createServer(app)
    .listen(config.connectPort)
    .on('listening', function () {
      console.log('Started connect web server on ' + config.connectDomain + ':' + config.connectPort);
    });
});

gulp.task('backend', function() {
  var server = $.nodemon({
    script: 'server.coffee',
    ignore: ['public/**', '.public/**']
  })
  server.on('restart', $.util.log.bind(null, 'BACRO UP IN IT AGAIN'));
  return server;
});

// inject bower components
gulp.task('wiredep', function () {
  var wiredep = require('wiredep').stream;

  gulp.src('public/styles/*.scss')
    .pipe(wiredep({
      directory: 'public/bower_components'
    }))
    .pipe(gulp.dest('public/styles'));

  gulp.src('public/*.html')
    .pipe(wiredep({
      directory: 'public/bower_components',
      exclude: ['bootstrap-sass-official']
    }))
    .pipe(gulp.dest('public'));
});

gulp.task('browserify', function () {
  return browserify({
      entries: ['./public/script/main.coffee'],
      extensions:['.coffee'] 
    })
    .bundle({debug:true})
    .on('error', $.util.log)
    .pipe(require('vinyl-source-stream')('main.js'))
    .pipe(gulp.dest('./.public/script/'));
});


gulp.task('watch', function () {
  var server = $.livereload();

  // watch for changes

  gulp.watch([
    'public/*.html',
    '.public/styles/**/*.css',
    '.public/script/**/*.js',
    'public/images/**/*'
  ]).on('change', function (file) {
    server.changed(file.path);
  });

  gulp.watch('public/styles/**/*.scss', ['styles']);
  //gulp.watch('public/script/**/*.js', ['scripts']);
  //gulp.watch('public/script/**/*.coffee', ['coffee']);
  gulp.watch('public/script/**/*.coffee', ['browserify']);
  gulp.watch('public/images/**/*', ['images']);
  //gulp.watch('bower.json', ['wiredep']);
});

gulp.task('default', ['backend', 'watch'], function () {
});

