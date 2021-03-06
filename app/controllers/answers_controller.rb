class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, only: [:destroy, :update, :mark_as_best, :delete_attachment]
  after_action :broadcast_answer, only: :create

  authorize_resource

  include Likes
  include Comments

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

  def delete_attachment
    if current_user.is_author?(@answer)
      @answer.delete_attachment(params[:delete_id])
      redirect_to @answer.question
    end
  end

  private

  def broadcast_answer
    ActionCable.server.broadcast("answers_stream_#{@question.id}", answer: @answer) unless @answer.errors.any?
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best, files: [], links_attributes: [:name, :url, :_destroy]).merge!(user_id: current_user.id)
  end
end
