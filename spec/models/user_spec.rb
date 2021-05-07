require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question1) { create(:question, user_id: user1.id) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many :answers }
  it { should have_many :questions }

  it { should have_many(:authorizations).dependent(:destroy) }

  context 'method User#is_author?' do
    it 'should return true in case self is resource\'s author' do
      expect(user1.is_author?(question1)).to eq true
    end

    it 'should return false in case self is not resource\'s author' do
      expect(user2.is_author?(question1)).to eq false
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:oauth_service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(oauth_service)
      expect(oauth_service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
