module.exports = function(arr, start) {
  if (start == null) {
    start = 0;
  }
  return Array.prototype.slice.call(arr, start);
};
