module Comments
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :create_comment
    after_action :broadcast_comment, only: :create_comment
  end

  def create_comment
    authorize! :create_comment, @commentable
    @comment = @commentable.comment(current_user, comment_params)
  end

  private

  def set_commentable
    @commentable = controller_name.classify.constantize.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def broadcast_comment
    if @commentable.class == 'Question'
      ActionCable.server.broadcast("comments_stream_#{@commentable.id}", comment: @comment) unless @comment.errors.any?
    end
  end

end
