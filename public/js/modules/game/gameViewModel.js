define(['ko'], function(ko) {
  var gameViewModel;
  gameViewModel = function() {
    this.acronym = ko.observable("RULRN");
    this.bacronymInput = ko.observable('ars');
    this.bacronymSubmit = function(formEl) {
      return console.log('bacronym submit');
    };
    return this;
  };
  return gameViewModel;
});
