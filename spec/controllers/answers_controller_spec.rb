require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  context 'Unauthenticated clearance' do
    describe 'access denied for' do
      it 'POST #create' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }
        expect(response).to redirect_to new_user_session_path
      end

      it 'DELETE #destroy' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to new_user_session_path
      end

      it 'PATCH #update' do
        patch :update, params: { id: answer, answer: { body: FFaker::Book.description } }
        expect(response).to redirect_to new_user_session_path
      end

      it 'POST #mark_as_best' do
        post :mark_as_best, params: { id: answer, question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'Authenticated clearance' do
    before { login(user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new answer in the DB' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }, format: :js }.to change(Answer, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user }, format: :js }.to_not change(Answer, :count)
        end

        it 'renders create view' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question.id }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    describe 'PATCH #update' do
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
      it 'sets best attribute of an answer to true' do
        post :mark_as_best, params: { id: answer, question_id: question.id }
        expect(assigns(:answer).best).to eq true
      end
    end
  end
end
