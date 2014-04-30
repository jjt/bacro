module.exports = (url, body)->
  $.ajax
    type: 'POST'
    url: url
    data: body
    dataType: 'json'
    headers:
      'X-CSRF-Token': csrftoken
