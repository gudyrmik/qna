require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let!(:count) { Answer.count }
    
    context 'with valid attributes' do
      before { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }

      it 'saves a new answer in the DB' do
        expect(Answer.count).to eq count + 1
      end

      it 'new answer belongs to appropriate question' do
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'redirects to show view' do # ну я его не писал потому что show не был в ТЗ:)
        expect(response).to render_template :show
      end
    end

    context 'with invalid attributes' do
      before { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }

      it 'does not save the question' do
        expect(Answer.count).to eq count
      end

      it 're-renders new view' do
        expect(response).to render_template :new
      end
    end
  end
end
