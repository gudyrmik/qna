class AnswersController < ApplicationController
  before_action :find_question, only: [:new, :create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    # так я спецом так и написал, render :new unless @answer.save, а потом рефактор:)
    if @answer.save
      # redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
