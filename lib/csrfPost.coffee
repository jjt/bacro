
module.exports = (url, body, success, error)->
  if not success?
    success = console.log.bind console
  if not error?
    error = console.log.bind console
  $.ajax
    type: 'POST'
    url: url
    data: body
    dataType: 'json'
    headers:
      'X-CSRF-Token': csrftoken
    success: success
    error: error
