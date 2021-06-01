require 'rails_helper'

describe 'Questions API', type: :request do
  let(:me) { create(:user) }
  let(:headers) {
    {
      "CONTENT-TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
  }
  let(:headers_no_content_type) {
    {
      "ACCEPT" => "application/json"
    }
  }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_attachment) }
    let!(:link) { create(:link, linkable: question) }
    let!(:comment) { create(:comment, commentable: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:request_params) { { access_token: access_token.token } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { do_request :get, api_path, params: request_params, headers: headers }

      it { expect(response).to be_successful }

      let(:resource) { question }
      let(:private_fields) { %w[password encrypted_password] }

      it_behaves_like 'Public Fields Returnable' do
        let(:public_fields) { %w[title body created_at updated_at] }
        let(:resource_response) { json['question'] }
      end

      include_examples 'Private Fields Non-Returnable' do
        let(:resource_response) { json['question']['user'] }
      end

      describe 'links' do
        let(:public_fields) { %w[url] }
        let(:resource_response) { json['question']['links'][0] }
        let(:resource) { question.links[0] }
        include_examples 'Public Fields Returnable'
      end

      describe 'comments' do
        let(:public_fields) { %w[body created_at updated_at] }
        let(:resource_response) { json['question']['comments'][0] }
        let(:resource) { question.comments[0] }
        include_examples 'Public Fields Returnable'
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question, answers: create_list(:answer, 2)) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:request_params) { { access_token: access_token.token } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before { do_request(:get, api_path, params: request_params, headers: headers) }

    it { expect(response).to be_successful }

    it 'returns answers to curent question' do
      expect(json['answers'].count).to eq 2
    end

    it 'returns all public attributes' do
      %w[body created_at updated_at user].each do |attr|
        expect(json['answers'][0]).to have_key(attr)
      end
    end

    it 'does not return private attributes' do
      %w[password encrypted_password].each do |attr|
        expect(json['answers'][0]['user']).to_not have_key(attr)
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :post }
    let(:headers) { headers_no_content_type }

    it_behaves_like 'API Authorizable'

    context 'valid question creation attempt' do
      let(:question) { { title: 'MyTitle', body: 'MyBody' } }
      let(:request_params) { { access_token: access_token.token, question: question } }

      before { do_request(method, api_path, params: request_params, headers: headers) }

      it { expect(response).to be_successful }

      include_examples 'Public Fields Returnable' do
        let(:public_fields) { %w[title body created_at updated_at] }
        let(:resource_response) { json['question'] }
        let(:resource) { Question.first }
      end
    end

    context 'invalid question creation attempt' do
      let(:question) { { title: 'MyTitle', body: '' } }
      let(:request_params) { { access_token: access_token.token, question: question } }

      before { do_request(method, api_path, params: request_params, headers: headers) }

      it 'returns fail status' do
        expect(response.status).to eq 422
      end

      it 'returns error message' do
        expect(json['errors']).to have_key('body')
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }
    let(:question) { create(:question, user: me) }
    let(:headers) { headers_no_content_type }

    it_behaves_like 'API Authorizable' do
      let(:request_params) {}
    end

    before { do_request method, api_path, params: request_params, headers: headers }

    context 'authorized' do
      let(:request_params1) { { access_token: access_token.token, question: { title: 'Other' } } }

      it 'returns success status' do
        expect(response).to be_successful
      end

      include_examples 'Public Fields Returnable' do
        let(:fields) { %w[id title body created_at updated_at] }
        let(:resource_response) { json['question'] }
        let(:resource) { Question.find(question.id) }
      end

      include_examples 'Resource Unauthorizable' do
        let(:question) { create(:question) }
        let(:request_params) { { access_token: access_token.token } }
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }
    let(:request_params) { { access_token: access_token.token } }
    before { do_request method, api_path, params: request_params, headers: headers}

    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question) }
    end

    include_examples 'Resource Unauthorizable' do
      let(:question) { create(:question) }
    end

    context 'authorized' do
      let(:question) { create(:question, user: me) }

      it 'returns successful status' do
        expect(response).to be_successful
      end

      it 'question not founded' do
        expect { Question.find(question.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      include_examples 'Public Fields Returnable' do
        let(:fields) { %w[id title body created_at updated_at] }
        let(:resource_response) { json['question'] }
        let(:resource) { question }
      end
    end
  end
end
