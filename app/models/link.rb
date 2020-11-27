class Link < ApplicationRecord

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::regexp(%w[http https]), message: "Invalid URL"}

  def gist_id
    if res = url.match(/https:\/\/gist.github.com\/\w+\/(\w+)/)
      res[0]
    end
  end

end
