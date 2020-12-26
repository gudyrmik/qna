module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end

  def comment(user, body)
    comments.create(user: user, body: body)
  end
end
