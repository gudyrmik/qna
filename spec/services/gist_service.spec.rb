require 'rails_helper'

RSpec.describe GistService, :vcr do

  let(:valid_gist_id) { '01b69e7c8d25e3dae082d8bb742b5973' }
  let(:invalid_gist_id) { '123' }

  describe 'GistService#call' do
    it 'returns content of the gist for valid gist id' do
      expect(GistService.new(valid_gist_id).call).to eq 'qna'
    end

    it 'returns false for invalid gist id' do
      expect(GistService.new(invalid_gist_id).call).to eq false
    end
  end
end
