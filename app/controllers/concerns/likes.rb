module Likes
  extend ActiveSupport::Concern

  included do
    before_action :set_likeable, only: [:like, :dislike, :discard_like]
  end

  def like
    authorize! :like, [Question, Answer]
    return render_errors if current_user.is_author?(@likeable)

    @likeable.like(current_user)
    render_json
  end

  def dislike
    return render_errors if current_user.is_author?(@likeable)

    @likeable.dislike(current_user)
    render_json
  end

  def discard_like
    return render_errors if current_user.is_author?(@likeable)

    @likeable.discard_like_of(current_user)
    render_json
  end

  private

  def render_json
    render json: { resourceName: @likeable.class.name.downcase, resourceId: @likeable.id, rating: @likeable.rating }
  end

  def render_errors
    render json: { message: "You're an author, or not authorized" }, status: 404
  end

  def set_likeable
    @likeable = controller_name.classify.constantize.find(params[:id])
  end
end
