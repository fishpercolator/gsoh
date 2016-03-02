class QuestionsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    authorize Question
    render inline: 'Nothing to see here... yet', layout: true
  end
  def answer
    @question = current_user.unanswered_questions&.first
    if @question
      authorize @question
      @remaining = current_user.unanswered_questions.count
      @total     = Question.count
      @answer = @question.answer_from(current_user)
    else
      flash[:notice] = 'All questions answered: here are your matches!'
      authorize Match, :index?
      redirect_to controller: :matches, action: :index
    end
  end
end
