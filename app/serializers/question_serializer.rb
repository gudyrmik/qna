class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  has_many :answers
  belongs_to :user
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer

  def short_title
    object.title.truncate(7)
  end
end
