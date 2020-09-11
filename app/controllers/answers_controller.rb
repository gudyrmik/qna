class AnswersController < ApplicationController
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: :destroy

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user.email
    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def destroy
    @answer.destroy if @answer.author == current_user.email
    redirect_to @answer.question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.permit(:body)
  end
end
