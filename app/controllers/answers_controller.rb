class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    question = current_user.unanswered_questions&.first
    if question
      @answer = question.answer_from(current_user)
      authorize @answer
    else
      flash[:notice] = 'All questions answered: here are your matches!'
      authorize Match, :index?
      redirect_to controller: :matches, action: :index
    end
  end
  
  def create
    @answer = Answer.new_with_type(answer_params)
    @answer.user = current_user
    authorize @answer
    if @answer.save
      # Next answer
      redirect_to action: 'new'
    else
      render action: 'new'
    end
  end
  
  private
  
  def answer_params
    params.require(:answer).permit(:question_id, :answer, :subtype)
  end
  
end
