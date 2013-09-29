define [
  'ko'
],
(ko) ->
  gameViewModel = () ->
    @acronym = ko.observable "RULRN"
    @bacronymInput = ko.observable 'ars'
    @bacronymSubmit = (formEl) ->
      console.log 'bacronym submit'
    this


  gameViewModel
