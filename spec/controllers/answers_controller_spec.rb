require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { Question.create(title: 'Title 1', body: 'Body 1', author: user.email) }
  let!(:answer) { question.answers.create(body: 'Body 1', author: user.email) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    let!(:count) { Answer.count }

    context 'with valid attributes' do
      before { post :create, params: { question_id: question.id, body: 'Answer body' } }

      it 'saves a new answer in the DB' do
        expect(Answer.count).to eq count + 1
      end

      it 'new answer belongs to appropriate question' do
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'redirects to question\'s show view' do
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      before { post :create, params: { question_id: question.id, body: nil } }

      it 'does not save the question' do
        expect(Answer.count).to eq count
      end

      it 're-renders new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer, question_id: question.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question\'s show' do
      delete :destroy, params: { id: answer, question_id: question.id }
      expect(response).to redirect_to question_path(question)
    end
  end
end
