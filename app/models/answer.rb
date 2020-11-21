class Answer < ApplicationRecord

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: true)
    end
  end

  def delete_attachment(id)
    file = self.files.find_by(id: id)
    file.purge unless file.nil?
  end
end
