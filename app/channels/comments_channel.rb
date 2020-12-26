class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_stream_#{params[:question_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
