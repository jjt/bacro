'use strict';
// generated on 2014-04-23 using generator-gulp-webapp 0.0.8

var gulp = require('gulp');
var browserify = require('browserify');
var runSeq = require('run-sequence');

var config = {
  connectDomain: 'http://bacro.node',
  connectPort: 3000,
  liveReloadPort: 35729
}

// load plugins
var $ = require('gulp-load-plugins')();

var errFn = function () {
  $.util.log.apply(null, arguments);
  this.emit('end');
}

gulp.task('styles', function () {
  return gulp.src('public/styles/main.scss')
    .pipe($.sourcemaps.init())
    .pipe($.sass({
      includePaths: ['public/bower_components']
    })).on('error', errFn.bind(this))
    .pipe($.sourcemaps.write('../maps'))
    .pipe($.autoprefixer('last 1 version'))
    .pipe(gulp.dest('.public/styles'))
    .pipe($.size())
    .pipe($.livereload());
});

gulp.task('coffee', function() {
  return gulp.src('public/script/**/*.coffee')
    .pipe($.coffee({bare: true})).on('error', errFn.bind(tnis))
    .pipe(gulp.dest('.public/script'));
});

gulp.task('coffeeServer', function(){
  return gulp.src('./server.coffee')
    .pipe($.coffee({bare: true})).on('error', errFn.bind(tnis))
    .pipe(gulp.dest('./'));
});

gulp.task('coffeeLib', function(){
  return gulp.src('./lib/**/*.coffee')
    .pipe($.coffee({bare: true})).on('error', errFn.bind(tnis))
    .pipe(gulp.dest('./lib'));
});

gulp.task('coffeeConfig', function(){
  return gulp.src('./config/**/*.coffee')
    .pipe($.coffee({bare: true})).on('error', errFn.bind(tnis))
    .pipe(gulp.dest('./config'));
});

gulp.task('coffeeApp', function(){
  return gulp.src('./app/**/*.coffee')
    .pipe($.coffee({bare: true})).on('error', errFn.bind(tnis))
    .pipe(gulp.dest('./app'));
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
    .pipe($.size())
    .pipe($.livereload());
});

gulp.task('distScripts', function(){
  return gulp.src('.public/script/**/*.js')
    .pipe(gulp.dest('dist/script'))
});

gulp.task('distStyles', function(){
  return gulp.src('.public/styles/**/*.css')
    .pipe(gulp.dest('dist/styles'))
})

gulp.task('fonts', function () {
  return $.bowerFiles()
    .pipe($.filter('**/*.{eot,svg,ttf,woff}'))
    .pipe($.flatten())
    .pipe(gulp.dest('dist/fonts'))
    .pipe($.size())
    .pipe($.livereload());
});

gulp.task('clean', function () {
  return gulp.src(['.public', 'dist'], { read: false }).pipe($.clean());
});

gulp.task('build', function () {
  return runSeq('clean',
    ['coffeeServer', 'coffeeConfig', 'coffeeLib'],
    ['browserify', 'html', 'images', 'fonts'],
    ['distStyles', 'distScripts']
  );
});

//gulp.task('connect', function () {
  //var connect = require('connect');
  //var app = connect()
    //.use(require('connect-livereload')({ port: config.liveReloadPort }))
    //.use(connect.static('public'))
    //.use(connect.static('.public'))
    //.use(connect.directory('public'));
//
  //require('http').createServer(app)
    //.listen(config.connectPort)
    //.on('listening', function () {
      //console.log('Started connect web server on ' + config.connectDomain + ':' + config.connectPort);
    //});
//});

gulp.task('backend', function() {
  var server = $.nodemon({
    script: 'server.coffee',
    ignore: ['public/**', '.public/**', 'node_modules'],
    env: require('./.env')
  })
  server.on('restart', errFn.bind(this, 'EXPRESS'));
  return server;
});

gulp.task('sock', function(){
  var server = $.nodemon({
    script: 'sock.coffee',
    ignore: ['public/**', '.public/**', 'app/**', 'node_modules']
  });

  server.on('restart', errFn.bind(this, 'SOCK'));
  return server;
})

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
      extensions:['.coffee', '.cjsx']
    })
    .bundle({debug:true})
    .on('error', function (err) {
      errFn.bind(this)(err);
      this.emit('end');
    })
    .pipe(require('vinyl-source-stream')('app-bundle.js'))
    .pipe(gulp.dest('./.public/script/'))
    .pipe($.livereload());
});



gulp.task('watch', function () {
  var server = $.livereload({start: true});

  gulp.watch('public/styles/**/*.scss', ['styles']);
  //gulp.watch('public/script/**/*.js', ['scripts']);
  //gulp.watch('public/script/**/*.coffee', ['coffee']);
  gulp.watch([
    'public/script/**/*.coffee',
    'public/script/**/*.cjsx'
  ],['browserify']);
  gulp.watch('public/images/**/*', ['images']);
  gulp.watch('server.coffee', ['coffeeServer']);
  gulp.watch('lib/**/*.coffee', ['coffeeLib']);
  gulp.watch('config/**/*.coffee', ['coffeeConfig']);
  //gulp.watch(['sock.coffee', 'lib/**'], ['sock']);
  //gulp.watch('bower.json', ['wiredep']);
});

gulp.task('default', ['backend', 'watch'], function () {
});

