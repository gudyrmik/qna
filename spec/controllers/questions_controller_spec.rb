require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  context 'Unauthenticated clearance' do
    describe 'GET #index' do
      let(:questions_array) { create_list(:question, rand(10...20)) }
      before { get :index }

      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(questions_array)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end

  context 'Authenticated clearance' do
    let(:question) { create(:question) }
    before { login(user) }

    describe 'GET #show' do
      before { get :show, params: { id: question } }

      it 'assigns requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'assigns new link for answer' do
        expect(assigns(:answer).links.first).to be_a_new(Link)
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      before { get :edit, params: { id: question } }

      it 'assigns requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new question in the DB' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'assigns requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          new_title = "Question from #{user.email}"
          new_body =  FFaker::Book.description
          patch :update, params: { id: question, question: { title: new_title, body: new_body } }
          question.reload
          expect(question.title).to eq new_title
          expect(question.body).to eq new_body
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        let(:initial_title) { question.title }
        let(:initial_body) { question.body }
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

        it 'does not change question' do
          question.reload
          expect(question.title).to eq initial_title
          expect(question.body).to eq initial_body
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'by author' do
        let!(:question) { create(:question, user_id: user.id) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'by non-author' do
        let!(:question) { create(:question) }

        it 'does not delete the question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end
    end
  end
end
