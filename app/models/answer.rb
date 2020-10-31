class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: true)
    end
  end
end
