import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id}, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel

    if (gon.current_user_id != null && gon.current_user_id == data['user_id']) { return; }

    var body = data['answer']['body']
    $('.answers#ans').append("New answer! " + body);
  }
});
