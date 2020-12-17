module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :destroy
  end

  def like(user)
    likes.create!(user: user, value: 1) unless is_like_of?(user)
  end

  def dislike(user)
    likes.create!(user: user, value: -1) unless is_like_of?(user)
  end

  def discard_like_of(user)
    likes.destroy_all if is_like_of?(user)
  end

  def rating
    likes.sum(:value)
  end

  def is_like_of?(user)
    likes.exists?(user: user)
  end
end
