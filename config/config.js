var path = require('path')
  , _ = require('lodash')
  , rootPath = path.normalize(__dirname + '/..')
  , templatePath = path.normalize(__dirname + '/../app/mailer/templates')
  , hostname = process.env.hostname || 'http://bacro.localdev.com'
  , notifier = {
      service: 'postmark',
      APN: false,
      email: false, // true
      actions: ['comment'],
      tplPath: templatePath,
      key: 'POSTMARK_KEY',
      parseAppId: 'PARSE_APP_ID',
      parseApiKey: 'PARSE_MASTER_KEY'
    }

module.exports = {
  development: {
    db: 'mongodb://localhost/bacro_dev',
    root: rootPath,
    notifier: notifier,
    app: {
      name: 'Nodejs Express Mongoose Demo'
    },
    facebook: {
      clientID: "APP_ID",
      clientSecret: "APP_SECRET",
      callbackURL: hostname + "/auth/facebook/callback"
    },
    twitter: {
      clientID: "CONSUMER_KEY",
      clientSecret: "CONSUMER_SECRET",
      callbackURL: hostname + "/auth/twitter/callback"
    },
    github: {
      clientID: 'APP_ID',
      clientSecret: 'APP_SECRET',
      callbackURL: 'http://bacro.localdev.com/auth/github/callback'
    },
    google: {
      clientID: "1059096846902-cbmdbhqphmne2tv2mduha2elfpljnrii.apps.googleusercontent.com",
      clientSecret: process.env.GOOGLE_SECRET || require('./googleSecret.LOCAL'),
      callbackURL: hostname + "/auth/google/callback"
    },
    linkedin: {
      clientID: "CONSUMER_KEY",
      clientSecret: "CONSUMER_SECRET",
      callbackURL: hostname + "/auth/linkedin/callback"
    }
  },
  test: {
    db: 'mongodb://localhost/bacro_test',
    root: rootPath,
    notifier: notifier,
    app: {
      name: 'Nodejs Express Mongoose Demo'
    },
    facebook: {
      clientID: "APP_ID",
      clientSecret: "APP_SECRET",
      callbackURL: hostname + "/auth/facebook/callback"
    },
    twitter: {
      clientID: "CONSUMER_KEY",
      clientSecret: "CONSUMER_SECRET",
      callbackURL: hostname + "/auth/twitter/callback"
    },
    github: {
      clientID: "APP_ID",
      clientSecret: "APP_SECRET",
      callbackURL: hostname + "/auth/github/callback"
    },
    google: {
      clientID: "APP_ID",
      clientSecret: "APP_SECRET",
      callbackURL: hostname + "/auth/google/callback"
    },
    linkedin: {
      clientID: "CONSUMER_KEY",
      clientSecret: "CONSUMER_SECRET",
      callbackURL: hostname + "/auth/linkedin/callback"
    }
  },
  production: {
    db: process.env.MONGOLAB_URI,
    root: rootPath,
    notifier: notifier,
    app: {
      name: 'Nodejs Express Mongoose Demo'
    },
    facebook: {
      clientID: "APP_ID",
      clientSecret: "APP_SECRET",
      callbackURL: hostname + "/auth/facebook/callback"
    },
    twitter: {
      clientID: "CONSUMER_KEY",
      clientSecret: "CONSUMER_SECRET",
      callbackURL: hostname + "/auth/twitter/callback"
    },
    github: {
      clientID: "APP_ID",
      clientSecret: "APP_SECRET",
      callbackURL: hostname + "/auth/github/callback"
    },
    google: {
      clientID: "APP_ID",
      clientSecret: process.env.GOOGLE_SECRET,
      callbackURL: hostname + "/auth/google/callback"
    },
    linkedin: {
      clientID: "CONSUMER_KEY",
      clientSecret: "CONSUMER_SECRET",
      callbackURL: hostname + "/auth/linkedin/callback"
    }
  }
}
