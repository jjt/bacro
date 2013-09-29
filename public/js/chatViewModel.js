define(['ko'], function(ko) {
  var ChatViewModel;
  ChatViewModel = function() {
    var self,
      _this = this;
    self = this;
    this.chatSubmit = function(formEl) {
      return console.log("chat submit");
    };
    return null;
  };
  return ChatViewModel;
});
