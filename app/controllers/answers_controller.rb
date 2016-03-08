class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_and_update_answer, only: [:create, :update]
  
  def index
    authorize Answer
  end
  
  def new
    question = current_user.unanswered_questions&.first
    if question
      @answer = question.answer_from(current_user)
      authorize @answer
      redirect_to edit_answer_path(question.id)
    else
      flash[:notice] = 'All questions answered: here are your matches!'
      authorize Match, :index?
      redirect_to matches_path
    end
  end
  
  def edit
    question = Question.find(params[:id]) || not_found
    @answer = question.answer_from(current_user)
    authorize @answer
  end
  
  def create
    if params[:skip]
      skip_answer
    elsif @answer.save
      # Next answer
      redirect_to new_answer_path
    else
      render action: 'edit'
    end
  end
  
  def update
    if @answer.save
      redirect_to answers_path
    else
      render action: 'edit'
    end
  end
  
  private
  
  def find_and_update_answer
    @answer = Answer.new_with_type(answer_params)
    @answer.user = current_user
    authorize @answer
  end
  
  def skip_answer
    # come full circle if we get to the end
    next_question = current_user.next_unanswered_question_after(answer_params[:question_id]) ||
      current_user.unanswered_questions.first
    redirect_to edit_answer_path(next_question.id)
  end
  
  def answer_params
    params.require(:answer).permit(:question_id, :answer, :subtype)
  end
  
end
