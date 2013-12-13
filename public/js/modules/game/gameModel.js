define([], function() {
  return function(opts) {
    if (opts == null) {
      opts = {};
    }
    this.id = opts.id;
    return this.acronym = opts.acronym;
  };
});
