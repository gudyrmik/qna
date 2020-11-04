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
      expect { delete :destroy, params: { id: answer, question_id: question.id }, format: :js }.to change(Answer, :count).by(-1)
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

  describe 'POST #mark_as_best' do

    let!(:answer2) { create(:answer, question: question, user: user) }
    let!(:answer3) { create(:answer, question: question, user: user) }

    before { login(user) }

    it 'sets best attribute of an answer to true' do
      post :mark_as_best, params: { id: answer, question_id: question.id }
      expect(assigns(:answer).best).to eq true
    end

    it 'makes sure that only one answer to current question has best attribute set on true' do
      post :mark_as_best, params: { id: answer }

      expect(assigns(:answer).best).to eq true
      expect(answer2.best).to eq false
      expect(answer3.best).to eq false
    end
  end
end
