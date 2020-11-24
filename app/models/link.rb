class Link < ApplicationRecord

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::regexp(%w[http https]), message: "Invalid URL"}

  def content
    if gist_id.present?
      GistService.new(gist_id).call
    else
      url
    end
  end

  def gist_id
    url.match(/https:\/\/gist.github.com\/\w+\/(\w+)/)[1] rescue nil
  end

end
