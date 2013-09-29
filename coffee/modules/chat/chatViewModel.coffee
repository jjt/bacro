define [
  'ko'
],
(ko) ->
  ChatViewModel = () ->
    self = this
    @chatSubmit = (formEl) =>
      console.log "chat submit"
    null

  ChatViewModel
