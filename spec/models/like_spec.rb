require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to :user }
  it { should belong_to :likeable }

  it { should validate_presence_of :value }
  it { should validate_presence_of :user }

  describe 'user should be unique' do
    let(:user) { create(:user) }
    let(:likeable_question) { create(:question, id: 1, user: user) }
    let(:likeable_answer) { create(:answer, id: 1, question: likeable_question, user: user) }
    let!(:liked_question) { create(:like, user: user, likeable: likeable_question, value: 1) }
    let!(:liked_answer) { create(:like, user: user, likeable: likeable_answer, value: 1) }

    it { should validate_uniqueness_of(:user).scoped_to([:likeable_id, :likeable_type]) }
  end
end
