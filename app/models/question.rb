class Question < ApplicationRecord

  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

  def delete_attachment(id)
    file = self.files.find_by(id: id)
    file.purge unless file.nil?
  end

end
