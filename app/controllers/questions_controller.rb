class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: :index
  before_action :find_question, only: [:edit, :show, :update, :destroy, :delete_attachment]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def edit
  end

  def delete_attachment
    if current_user.is_author?(@question)
      @question.delete_attachment(params[:delete_id])
      redirect_to @question, notice: 'Your attachment was succsessfully deleted.'
    end
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question succsessfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy if current_user.is_author?(@question)
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def find_attachments
    @attachments = @question.files
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url]).merge!(user_id: current_user.id)
  end
end
