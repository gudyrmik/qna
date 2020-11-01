class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, only: [:destroy, :update, :mark_as_best]

  def create
    @answer = @question.answers.create(answer_params)
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.is_author?(@answer)
  end

  def mark_as_best
    @question = @answer.question
    @answer.mark_as_best if current_user.is_author?(@question)
    redirect_to @question
  end

  def update
    if current_user.is_author?(@answer)
      @question = @answer.question
      @answer.update(answer_params)
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best).merge!(user_id: current_user.id)
  end
end
