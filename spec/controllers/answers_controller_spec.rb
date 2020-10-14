require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    let!(:count) { Answer.count }

    context 'with valid attributes' do
      before { post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user.id }, format: :js }

      it 'saves a new answer in the DB' do
        expect(Answer.count).to eq count + 1
      end

      it 'new answer belongs to appropriate question' do
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'renders create view' do
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user.id }, format: :js }

      it 'does not save the question' do
        expect(Answer.count).to eq count
      end

      it 'renders create view' do
        expect(response).to render_template :create
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

  describe 'PATCH #update' do

    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq('new body')
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
