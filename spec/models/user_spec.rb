require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question1) { create(:question, user_id: user1.id) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many :answers }
  it { should have_many :questions }

  context 'method User#is_author?' do
    it 'should return true in case self is resource\'s author' do
      expect(user1.is_author?(question1)).to eq true
    end

    it 'should return false in case self is not resource\'s author' do
      expect(user2.is_author?(question1)).to eq false
    end
  end
end
