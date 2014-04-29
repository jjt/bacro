(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Chat, Game, Lobby, R, clargs, csrfPost, cx, fbRoot, fbRootURL, router, show;

R = React.DOM;

cx = React.addons.classSet;

fbRootURL = 'https://bacrogame.firebaseio.com';

fbRoot = new Firebase(fbRootURL);

clargs = function() {
  return console.log(arguments);
};

csrfPost = function(url, body) {
  return $.ajax({
    type: 'POST',
    url: url,
    data: body,
    dataType: 'json',
    headers: {
      'X-CSRF-Token': csrftoken
    }
  });
};

ReactMultiplayerMixin.setFirebaseRoot(fbRoot);

Chat = React.createClass({
  setFbRef: function(props) {
    var fbRef;
    console.log('setFbref');
    fbRef = fbRoot.child("chats/" + props.gameId);
    fbRef.once('value', (function(_this) {
      return function(snapshot) {
        var chats;
        chats = _.values(snapshot.val());
        chats = _.sortBy(chats, 'id');
        return _this.setState({
          chats: chats
        });
      };
    })(this));
    return fbRef.on('child_added', (function(_this) {
      return function(snapshot) {
        var chats, msg;
        msg = snapshot.val();
        chats = _this.state.chats;
        chats.push(msg);
        return _this.setState({
          chats: chats
        });
      };
    })(this));
  },
  componentDidUpdate: function() {
    var $chats;
    console.log('cDU');
    $chats = this.refs.chats.getDOMNode();
    return $chats.scrollTop = $chats.scrollHeight;
  },
  componentWillMount: function() {
    console.log('cWM');
    return this.setFbRef(this.props);
  },
  componentWillRecieveProps: function(nextProps) {
    console.log('cWRP', nextProps);
    return this.setFbRef(nextProps);
  },
  getInitialState: function() {
    return {
      chats: []
    };
  },
  handleChatSubmit: function() {
    var $input;
    $input = this.refs.chatInput.getDOMNode();
    csrfPost("/game/" + this.props.gameId + "/chat", {
      msg: $input.value,
      channel: this.props.gameId
    });
    $input.value = '';
    return false;
  },
  render: function() {
    console.log(this.state.chats);
    return R.div({
      className: 'Chat'
    }, [
      R.div({
        className: 'Chat-chats',
        ref: 'chats'
      }, this.state.chats.map(function(el) {
        return R.div({}, [R.strong({}, el.user), ": " + el.msg]);
      })), R.form({
        className: 'form',
        onSubmit: this.handleChatSubmit
      }, [
        R.div({
          className: 'input-group'
        }, [
          R.input({
            className: 'Chat-input form-control',
            ref: 'chatInput',
            placeholder: 'Type to chat'
          }), R.span({
            className: 'input-group-btn'
          }, R.button({
            className: 'btn btn-primary'
          }, 'Chat'))
        ])
      ])
    ]);
  }
});

Lobby = React.createClass({
  render: function() {
    return R.div({
      className: 'Lobby'
    }, [
      R.h1({}, 'Lobby'), R.div({
        id: 'gameList',
        ref: 'gameList'
      }), R.div({
        id: 'userList',
        ref: 'userList'
      }), R.a({
        className: 'btn btn-primary',
        href: '#/newgame'
      }, 'New Game')
    ]);
  }
});

Game = React.createClass({
  componentWillMount: function() {
    var fb;
    fb = fbRoot.child("games/" + this.props.id);
    return fb.set({
      round: 1
    });
  },
  render: function() {
    return R.div({
      className: 'Game'
    }, [
      R.h1({}, "Game " + this.props.id), Chat({
        gameId: this.props.id
      })
    ]);
  }
});

show = function(component, props) {
  if (props == null) {
    props = {};
  }
  return React.renderComponent(component(props), document.getElementById('app'));
};

router = new Router({
  '/lobby': function() {
    return show(Lobby);
  },
  '/new': function() {
    return $.get('/game/new', (function(_this) {
      return function(resp) {
        return _this.setRoute("/" + resp);
      };
    })(this));
  },
  '/:id': function(id) {
    console.log('show game id ' + id);
    return show(Game, {
      id: id,
      key: id
    });
  }
});

router.init('/lobby');


},{}]},{},[1])
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvVXNlcnMvamp0L1NpdGVzL2JhY3JvL25vZGVfbW9kdWxlcy9icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvVXNlcnMvamp0L1NpdGVzL2JhY3JvL3B1YmxpYy9zY3JpcHQvbWFpbi5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7QUNBQSxJQUFBLDJFQUFBOztBQUFBLENBQUEsR0FBSSxLQUFLLENBQUMsR0FBVixDQUFBOztBQUFBLEVBQ0EsR0FBSyxLQUFLLENBQUMsTUFBTSxDQUFDLFFBRGxCLENBQUE7O0FBQUEsU0FHQSxHQUFZLGtDQUhaLENBQUE7O0FBQUEsTUFJQSxHQUFhLElBQUEsUUFBQSxDQUFTLFNBQVQsQ0FKYixDQUFBOztBQUFBLE1BTUEsR0FBUyxTQUFBLEdBQUE7U0FBSyxPQUFPLENBQUMsR0FBUixDQUFZLFNBQVosRUFBTDtBQUFBLENBTlQsQ0FBQTs7QUFBQSxRQVFBLEdBQVcsU0FBQyxHQUFELEVBQU0sSUFBTixHQUFBO1NBQ1QsQ0FBQyxDQUFDLElBQUYsQ0FDRTtBQUFBLElBQUEsSUFBQSxFQUFNLE1BQU47QUFBQSxJQUNBLEdBQUEsRUFBSyxHQURMO0FBQUEsSUFFQSxJQUFBLEVBQU0sSUFGTjtBQUFBLElBR0EsUUFBQSxFQUFVLE1BSFY7QUFBQSxJQUlBLE9BQUEsRUFDRTtBQUFBLE1BQUEsY0FBQSxFQUFnQixTQUFoQjtLQUxGO0dBREYsRUFEUztBQUFBLENBUlgsQ0FBQTs7QUFBQSxxQkFrQnFCLENBQUMsZUFBdEIsQ0FBc0MsTUFBdEMsQ0FsQkEsQ0FBQTs7QUFBQSxJQW9CQSxHQUFPLEtBQUssQ0FBQyxXQUFOLENBRUw7QUFBQSxFQUFBLFFBQUEsRUFBVSxTQUFDLEtBQUQsR0FBQTtBQUNSLFFBQUEsS0FBQTtBQUFBLElBQUEsT0FBTyxDQUFDLEdBQVIsQ0FBWSxVQUFaLENBQUEsQ0FBQTtBQUFBLElBQ0EsS0FBQSxH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O0tBQTNCLEVBRE07RUFBQSxDQUxSO0NBREssQ0FqR1AsQ0FBQTs7QUFBQSxJQThHQSxHQUFPLFNBQUMsU0FBRCxFQUFZLEtBQVosR0FBQTs7SUFBWSxRQUFNO0dBQ3ZCO1NBQUEsS0FBSyxDQUFDLGVBQU4sQ0FBc0IsU0FBQSxDQUFVLEtBQVYsQ0FBdEIsRUFBd0MsUUFBUSxDQUFDLGNBQVQsQ0FBd0IsS0FBeEIsQ0FBeEMsRUFESztBQUFBLENBOUdQLENBQUE7O0FBQUEsTUFpSEEsR0FBYSxJQUFBLE1BQUEsQ0FDWDtBQUFBLEVBQUEsUUFBQSxFQUFVLFNBQUEsR0FBQTtXQUNSLElBQUEsQ0FBSyxLQUFMLEVBRFE7RUFBQSxDQUFWO0FBQUEsRUFFQSxNQUFBLEVBQVEsU0FBQSxHQUFBO1dBQ04sQ0FBQyxDQUFDLEdBQUYsQ0FBTSxXQUFOLEVBQW1CLENBQUEsU0FBQSxLQUFBLEdBQUE7YUFBQSxTQUFDLElBQUQsR0FBQTtlQUNqQixLQUFDLENBQUEsUUFBRCxDQUFXLEdBQUEsR0FBRSxJQUFiLEVBRGlCO01BQUEsRUFBQTtJQUFBLENBQUEsQ0FBQSxDQUFBLElBQUEsQ0FBbkIsRUFETTtFQUFBLENBRlI7QUFBQSxFQUtBLE1BQUEsRUFBUSxTQUFDLEVBQUQsR0FBQTtBQUNOLElBQUEsT0FBTyxDQUFDLEdBQVIsQ0FBWSxlQUFBLEdBQWtCLEVBQTlCLENBQUEsQ0FBQTtXQUNBLElBQUEsQ0FBSyxJQUFMLEVBQVc7QUFBQSxNQUFDLEVBQUEsRUFBSSxFQUFMO0FBQUEsTUFBUyxHQUFBLEVBQUssRUFBZDtLQUFYLEVBRk07RUFBQSxDQUxSO0NBRFcsQ0FqSGIsQ0FBQTs7QUFBQSxNQTJITSxDQUFDLElBQVAsQ0FBWSxRQUFaLENBM0hBLENBQUEiLCJzb3VyY2VzQ29udGVudCI6WyIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3Rocm93IG5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIil9dmFyIGY9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGYuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sZixmLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSIsIlIgPSBSZWFjdC5ET01cbmN4ID0gUmVhY3QuYWRkb25zLmNsYXNzU2V0XG5cbmZiUm9vdFVSTCA9ICdodHRwczovL2JhY3JvZ2FtZS5maXJlYmFzZWlvLmNvbSdcbmZiUm9vdCA9IG5ldyBGaXJlYmFzZSBmYlJvb3RVUkxcblxuY2xhcmdzID0gKCktPiBjb25zb2xlLmxvZyBhcmd1bWVudHNcblxuY3NyZlBvc3QgPSAodXJsLCBib2R5KS0+XG4gICQuYWpheFxuICAgIHR5cGU6ICdQT1NUJ1xuICAgIHVybDogdXJsXG4gICAgZGF0YTogYm9keVxuICAgIGRhdGFUeXBlOiAnanNvbidcbiAgICBoZWFkZXJzOlxuICAgICAgJ1gtQ1NSRi1Ub2tlbic6IGNzcmZ0b2tlblxuXG5cblJlYWN0TXVsdGlwbGF5ZXJNaXhpbi5zZXRGaXJlYmFzZVJvb3QgZmJSb290XG5cbkNoYXQgPSBSZWFjdC5jcmVhdGVDbGFzc1xuICBcbiAgc2V0RmJSZWY6IChwcm9wcyktPlxuICAgIGNvbnNvbGUubG9nICdzZXRGYnJlZidcbiAgICBmYlJlZiA9IGZiUm9vdC5jaGlsZCBcImNoYXRzLyN7cHJvcHMuZ2FtZUlkfVwiXG4gICAgI2ZiUmVmLnB1c2hcbiAgICAgICN1c2VyOiBcIlRFU1RPXCJcbiAgICAgICNtc2c6IFwiI3sobmV3IERhdGUpLmdldFRpbWUoKX0gSEVFRVlZWVlZXCJcblxuICAgIGZiUmVmLm9uY2UgJ3ZhbHVlJywgKHNuYXBzaG90KT0+XG4gICAgICBjaGF0cyA9IF8udmFsdWVzIHNuYXBzaG90LnZhbCgpXG4gICAgICBjaGF0cyA9IF8uc29ydEJ5IGNoYXRzLCAnaWQnXG4gICAgICBAc2V0U3RhdGUge2NoYXRzfVxuXG4gICAgZmJSZWYub24gJ2NoaWxkX2FkZGVkJywgKHNuYXBzaG90KT0+XG4gICAgICBtc2cgPSBzbmFwc2hvdC52YWwoKVxuICAgICAgY2hhdHMgPSBAc3RhdGUuY2hhdHNcbiAgICAgIGNoYXRzLnB1c2ggbXNnXG4gICAgICBAc2V0U3RhdGUge2NoYXRzfVxuXG4gIGNvbXBvbmVudERpZFVwZGF0ZTogKCktPlxuICAgIGNvbnNvbGUubG9nICdjRFUnXG4gICAgJGNoYXRzID0gQHJlZnMuY2hhdHMuZ2V0RE9NTm9kZSgpXG4gICAgJGNoYXRzLnNjcm9sbFRvcCA9ICRjaGF0cy5zY3JvbGxIZWlnaHRcblxuICBjb21wb25lbnRXaWxsTW91bnQ6ICgpLT5cbiAgICBjb25zb2xlLmxvZyAnY1dNJ1xuICAgIEBzZXRGYlJlZiBAcHJvcHNcblxuICBjb21wb25lbnRXaWxsUmVjaWV2ZVByb3BzOiAobmV4dFByb3BzKS0+XG4gICAgY29uc29sZS5sb2cgJ2NXUlAnLCBuZXh0UHJvcHNcbiAgICBAc2V0RmJSZWYgbmV4dFByb3BzXG5cbiAgZ2V0SW5pdGlhbFN0YXRlOiAoKS0+XG4gICAgY2hhdHM6IFtdXG5cbiAgaGFuZGxlQ2hhdFN1Ym1pdDogKCktPlxuICAgICRpbnB1dCA9IEByZWZzLmNoYXRJbnB1dC5nZXRET01Ob2RlKClcbiAgICBjc3JmUG9zdCBcIi9nYW1lLyN7QHByb3BzLmdhbWVJZH0vY2hhdFwiLFxuICAgICAgbXNnOiAkaW5wdXQudmFsdWVcbiAgICAgIGNoYW5uZWw6IEBwcm9wcy5nYW1lSWRcblxuICAgICRpbnB1dC52YWx1ZSA9ICcnXG4gICAgIyQucG9zdCBcIi9nYW1lLyN7QHByb3BzLmdhbWVJZH0vY2hhdFwiLCB7bXNnfVxuICAgIHJldHVybiBmYWxzZVxuXG4gIHJlbmRlcjogLT5cbiAgICBjb25zb2xlLmxvZyBAc3RhdGUuY2hhdHNcbiAgICBSLmRpdiB7Y2xhc3NOYW1lOiAnQ2hhdCd9LCBbXG4gICAgICBSLmRpdiB7Y2xhc3NOYW1lOiAnQ2hhdC1jaGF0cycsIHJlZjogJ2NoYXRzJ30sIEBzdGF0ZS5jaGF0cy5tYXAgKGVsKS0+XG4gICAgICAgIFIuZGl2IHt9LCBbXG4gICAgICAgICAgUi5zdHJvbmcge30sIGVsLnVzZXJcbiAgICAgICAgICBcIjogXCIgKyBlbC5tc2dcbiAgICAgICAgXVxuICAgICAgUi5mb3JtIHtjbGFzc05hbWU6ICdmb3JtJywgb25TdWJtaXQ6IEBoYW5kbGVDaGF0U3VibWl0IH0sIFtcbiAgICAgICAgUi5kaXYge2NsYXNzTmFtZTogJ2lucHV0LWdyb3VwJ30sIFtcbiAgICAgICAgICBSLmlucHV0XG4gICAgICAgICAgICBjbGFzc05hbWU6ICdDaGF0LWlucHV0IGZvcm0tY29udHJvbCdcbiAgICAgICAgICAgIHJlZjogJ2NoYXRJbnB1dCdcbiAgICAgICAgICAgIHBsYWNlaG9sZGVyOiAnVHlwZSB0byBjaGF0J1xuICAgICAgICAgIFIuc3BhbiB7Y2xhc3NOYW1lOiAnaW5wdXQtZ3JvdXAtYnRuJ30sXG4gICAgICAgICAgICBSLmJ1dHRvbiB7Y2xhc3NOYW1lOiAnYnRuIGJ0bi1wcmltYXJ5J30sICdDaGF0J1xuICAgICAgICBdXG4gICAgICBdXG4gICAgXVxuICAgICAgXG5cbkxvYmJ5ID0gUmVhY3QuY3JlYXRlQ2xhc3NcbiAgcmVuZGVyOiAtPlxuICAgIFIuZGl2IHtjbGFzc05hbWU6ICdMb2JieSd9LCBbXG4gICAgICBSLmgxIHt9LCAnTG9iYnknXG4gICAgICBSLmRpdiB7aWQ6ICdnYW1lTGlzdCcsIHJlZjogJ2dhbWVMaXN0J31cbiAgICAgIFIuZGl2IHtpZDogJ3VzZXJMaXN0JywgcmVmOiAndXNlckxpc3QnfVxuICAgICAgUi5hIHtjbGFzc05hbWU6ICdidG4gYnRuLXByaW1hcnknLCBocmVmOiAnIy9uZXdnYW1lJ30sICdOZXcgR2FtZSdcbiAgICBdXG4gICAgICAgXG5cbkdhbWUgPSBSZWFjdC5jcmVhdGVDbGFzc1xuICBjb21wb25lbnRXaWxsTW91bnQ6IC0+XG4gICAgZmIgPSBmYlJvb3QuY2hpbGQgXCJnYW1lcy8je0Bwcm9wcy5pZH1cIlxuICAgIGZiLnNldFxuICAgICAgcm91bmQ6MVxuXG4gIHJlbmRlcjogLT5cbiAgICBSLmRpdiB7Y2xhc3NOYW1lOiAnR2FtZSd9LCBbXG4gICAgICBSLmgxIHt9LCBcIkdhbWUgI3tAcHJvcHMuaWR9XCJcbiAgICAgIENoYXQgZ2FtZUlkOiBAcHJvcHMuaWRcbiAgICBdXG5cblxuc2hvdyA9IChjb21wb25lbnQsIHByb3BzPXt9KS0+XG4gIFJlYWN0LnJlbmRlckNvbXBvbmVudCBjb21wb25lbnQocHJvcHMpLCBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgnYXBwJylcblxucm91dGVyID0gbmV3IFJvdXRlclxuICAnL2xvYmJ5JzogKCktPlxuICAgIHNob3cgTG9iYnlcbiAgJy9uZXcnOiAoKS0+XG4gICAgJC5nZXQgJy9nYW1lL25ldycsIChyZXNwKT0+XG4gICAgICBAc2V0Um91dGUgXCIvI3tyZXNwfVwiXG4gICcvOmlkJzogKGlkKS0+XG4gICAgY29uc29sZS5sb2cgJ3Nob3cgZ2FtZSBpZCAnICsgaWRcbiAgICBzaG93IEdhbWUsIHtpZDogaWQsIGtleTogaWR9XG5cbnJvdXRlci5pbml0KCcvbG9iYnknKVxuIl19