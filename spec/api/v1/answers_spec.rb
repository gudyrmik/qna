require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id).token }
  let(:fields) { %w[body created_at updated_at question_id] }

  describe 'GET /api/v1/answers/:id' do
    let(:request_params) { { access_token: access_token } }
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:answer) { create(:answer, :with_files) }
    let!(:link) { create(:link, linkable: answer) }
    let!(:comment) { create(:comment, commentable: answer) }

    it_behaves_like 'API Authorizable'

    before { do_request method, api_path, params: request_params, headers: headers }

    describe 'authorize' do
      it { expect(response).to be_successful }
      include_examples 'public fields returnable' do
        let(:resource_response) { json['answer'] }
        let(:resource) { answer }
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }
    let(:answer_params) { { body: 'NewBody' } }
    let(:request_params) { { access_token: access_token, answer: answer_params } }

    include_examples 'API Authorizable' do
      let(:question) { create(:question) }
    end

    before { do_request method, api_path, params: request_params, headers: headers }

    describe 'authorize' do
      let(:question) { create(:question) }

      it_behaves_like 'Public Fields Returnable' do
        let(:resource_response) { json['answer'] }
        let(:resource) { Answer.first }
      end

      it_behaves_like 'Private Fields Non-Returnable' do
        let(:private_fields) { %w[password encrypted_password] }
        let(:resource_response) { json['answer']['user'] }
        let(:resource) { Answer.first.user }
      end
    end
  end

  describe 'PATCH /api/v1/answer/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :patch }
    let(:answer_params) { { body: 'NewBody' } }
    let(:request_params) { { access_token: access_token, answer: answer_params } }

    include_examples 'API Authorizable' do
      let(:answer) { create(:answer) }
    end

    before { do_request method, api_path, params: request_params, headers: headers }

    context 'authorized' do
      let(:answer) { create(:answer, user: me) }

      it { expect(response).to be_successful }

      include_examples 'Public Fields Returnable' do
        let(:resource_response) { json['answer'] }
        let(:resource) { Answer.first }
      end
    end
  end

  describe 'DELETE /api/v1/answer/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }
    let(:request_params) { { access_token: access_token } }

    include_examples 'API Authorizable'

    before { do_request method, api_path, params: request_params, headers: headers }

    context 'authorized' do
      let(:answer) { create(:answer, user: me) }

      it { expect(response).to be_successful }
      it { expect { Answer.find(answer.id) }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
