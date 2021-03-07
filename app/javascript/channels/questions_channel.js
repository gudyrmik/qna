import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel

    if (gon.current_user_id != null && gon.current_user_id == data['user_id']) { return; }

    var title = "New question!<p><a href=questions/" + data['question']['id'] + ">" + data['question']['title'] + "</a></p>"
    // var edit = "<p><a href=questions/" + data['question']['id'] + "/edit>Edit " + data['question']['title'] + "</p>"
    // var del = "<p><a href=questions/" + data['question']['id'] + " data-method=\"delete\">Delete " + data['question']['title'] + "</p>"

    $('.questions').append(title);
  }
});
