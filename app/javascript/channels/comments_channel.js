import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
    connected() {
        // Called when the subscription is ready for use on the server
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        // Called when there's incoming data on the websocket for this channel

        if (gon.current_user != null && gon.current_user.id == data['user_id']) { return; }

        var body = data['comment']['body']
        $('.comments').append("New comment appeared: " + body);
    }
});
