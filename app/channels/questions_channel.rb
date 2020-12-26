class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'questions_stream'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
