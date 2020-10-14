class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def assure_best_uniq
    unless self.best
      best_answer = Answer.find_by(best: true)
      unless best_answer.nil?
        best_answer.best = false
        best_answer.save!
      end
    end
  end
end
