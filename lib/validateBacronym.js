module.exports = function(bacronym, acronym) {
  return acronym === bacronym.split(' ').map(function(token) {
    return token.charAt(0);
  }).join('').toUpperCase();
};
