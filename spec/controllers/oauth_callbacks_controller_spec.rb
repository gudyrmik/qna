require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    context 'User exists' do
      let!(:user) { create(:user) }
      let(:oauth_data) { {'provider' => 'github', 'uid' => '123' } }

      it 'finds user from auth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(:oauth_data)
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end
    end

    context 'User does not exist' do
      it 'does not login user' do
        expect(subject).to_not be
      end

      it 'redirects to root path' do
        allow(User).to receive(:find_for_oauth)
        get :github

        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'Vkontakte' do

  end
end
