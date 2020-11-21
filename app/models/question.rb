class Question < ApplicationRecord

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  def delete_attachment(id)
    file = self.files.find_by(id: id)
    file.purge unless file.nil?
  end

end
