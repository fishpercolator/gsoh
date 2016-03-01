class AnswersController < ApplicationController
  
  def create
    @answer = Answer.new_with_type(answer_params)
    @answer.user = current_user
    authorize @answer
    if @answer.save
      # Next answer
      redirect_to controller: 'questions', action: 'answer'
    else
      abort 'GAH FIXME'
    end
  end
  
  private
  
  def answer_params
    params.require(:answer).permit(:question_id, :answer, :subtype)
  end
  
end
