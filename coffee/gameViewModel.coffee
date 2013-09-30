define [
  'ko'
],
(ko) ->
  gameViewModel = () ->
    @acronym = ko.observable "RULRN"
    @bacronymInput = ko.observable ""
    @bacronymSubmit = (formEl) ->
      console.log 'bacronym submit'
    this


  gameViewModel
