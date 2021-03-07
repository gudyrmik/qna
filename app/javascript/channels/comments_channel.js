import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    connected() {
        // Called when the subscription is ready for use on the server
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        // Called when there's incoming data on the websocket for this channel

        // if (gon.current_user_id != null && gon.current_user_id == data['user_id']) { return; }

        var body = data['comment']['body']
        $('.comments#ques').append("New comment! " + body);
        // console.log("body: " + body)
        // console.log("$('.comments#ques') = " + $('.comments#ques'))
    }
});
