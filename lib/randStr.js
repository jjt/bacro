module.exports = function(len) {
  if (len == null) {
    len = 8;
  }
  return Math.random().toString(36).slice(2, len + 2);
};
