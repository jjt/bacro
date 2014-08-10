module.exports = {
  url: 'https://bacrogame.firebaseio.com',
  secret: process.env.FIREBASE_SECRET || require('./firebase.secret.LOCAL')
};
