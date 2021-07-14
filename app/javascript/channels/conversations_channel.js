import consumer from "./consumer"

consumer.subscriptions.create("ConversationsChannel", {
  connected() {
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    let chat_box = $(`#chat-box-${data.conversation_id}`);
    let chat_messages = $(`#list-massages-${data.conversation_id}`)
    $.fn.not_exists = function () {
      return this.length == 0;
    }
    if (chat_box.not_exists()) {
      $("#chat-list").html(data.conversation);
    } 
    else {
      chat_messages.append(data.messages) 
    }
  }
});
