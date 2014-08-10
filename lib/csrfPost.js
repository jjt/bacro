module.exports = function(url, body, success, error) {
  if (success == null) {
    success = console.log.bind(console);
  }
  if (error == null) {
    error = console.log.bind(console);
  }
  return $.ajax({
    type: 'POST',
    url: url,
    data: body,
    dataType: 'json',
    headers: {
      'X-CSRF-Token': csrftoken
    },
    success: success,
    error: error
  });
};
