class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :value, presence: true
  validates :user, presence: true, uniqueness: { scope: [:likeable_id, :likeable_type] }
end
