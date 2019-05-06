App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function () { },
  disconnected: function () { },
  received: function (data) {
    var conversation = $('#conversations-list').find("[data-conversation-id='" + data['conversation_id'] + "']");

    if (data['window'] !== undefined) {
      var conversation_visible = conversation.is(':visible');

      if (conversation_visible) {
        var messages_visible = (conversation).find('.panel-body').is(':visible');

        if (!messages_visible) {
          conversation.removeClass('panel-default').addClass('panel-success');
        }
        console.log(data)
        conversation.find('.messages-list').find('ul').append(data['message']);
        eval(data['funct'])
      }
      else {
        $('#conversations-list').append(data['window']);
        conversation = $('#conversations-list').find("[data-conversation-id='" + data['conversation_id'] + "']");
        conversation.find('.panel-body').toggle();
      }
    }
    else {
      console.log(data)

      conversation.find('ul').append(data['message']);
      eval(data['funct'])

      // conversation.find('ul').append(data['funct']);

    }

    var messages_list = conversation.find('.messages-list');
    var height = messages_list[0].scrollHeight;
    messages_list.scrollTop(height);
  },
  speak: function (message, funct = "alert('3333')") {
    return this.perform('speak', {
      message: message,
      funct: funct
    });
  }
});
$(document).on('submit', '.new_message', function (e) {
  e.preventDefault();
  var values = $(this).serializeArray();
  App.conversation.speak(values);
  $(this).trigger('reset');
});

