class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: :destroy

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question)
    else
      render question_path(@question)
    end
  end

  def destroy
    @answer.destroy if current_user.is_author?(@answer)
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
    params.permit(:body).merge!(user_id: current_user.id)
  end
end
