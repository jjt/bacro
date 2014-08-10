var clog;

clog = function(msg) {
  console.log("" + this.displayName + ": " + msg, Array.prototype.slice.call(arguments, 1));
  return true;
};

module.exports = {
  componentWillMount: clog.bind(this, 'componentWillMount'),
  componentDidMount: clog.bind(this, 'componentDidMount'),
  componentWillReceiveProps: clog.bind(this, 'componentWillReceiveProps'),
  componentWillUpdate: clog.bind(this, 'componentWillUpdate'),
  componentDidUpdate: clog.bind(this, 'componentDidUpdate'),
  componentWillUnmount: clog.bind(this, 'componentWillUnmount'),
  shouldComponentUpdate: clog.bind(this, 'shouldComponentUpdate')
};
