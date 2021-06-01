require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {
    {
      "CONTENT-TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
  }
  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 5) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request :get, '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it 'return status 200' do
        expect(response).to be_successful
      end

      it 'returns all users except me' do
        expect(json['users'].count).to eq 5
      end

      it 'does not return current_user' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end
    end
  end
end
