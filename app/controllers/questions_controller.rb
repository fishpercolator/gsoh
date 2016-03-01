class QuestionsController < ApplicationController
  def index
    authorize Question
    render inline: 'Nothing to see here... yet', layout: true
  end
  def answer
    @question = current_user&.unanswered_questions&.first
    if @question
      authorize @question
      @remaining = current_user.unanswered_questions.count
      @total     = Question.count
      @answer = @question.answer_from(current_user)
    else
      # FIXME: Should redirect to matches
      flash[:notice] = 'All questions answered!'
      authorize Question
      redirect_to action: :index
    end
  end
end
