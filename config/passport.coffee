module.exports = (passport) ->
  GoogleStrategy = require('passport-google').Strategy
  googleStrategyConfig =
    returnURL: 'http://bacro.node/auth/google/return'
    realm: 'http://bacro.node/'

  passport.use new GoogleStrategy googleStrategyConfig, (id, profile, done) ->
    profile.id = id
    done null, profile

  passport.serializeUser (user, done) ->
    done null, user

  passport.deserializeUser (obj, done) ->
    done null, obj

