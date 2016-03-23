class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @answers = policy_scope(Answer).where(user: current_user).order(:question_id)
    if @answers.empty?
      flash[:error] = 'No answers found. Please answer some questions below.'
      redirect_to new_answer_path
    end
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
    @progress = (current_user.answers.count * 100) / Question.count
    authorize @answer
  end
  
  def create
    @answer = Answer.new_with_type(answer_params)
    @answer.user = current_user
    authorize @answer
    return skip_answer if params[:skip]
    if @answer.save
      # Next answer
      redirect_to new_answer_path
    else
      render action: 'edit'
    end
  end
  
  def update
    @answer = Answer.find(params[:id])
    authorize @answer
    @answer.update_attributes(answer_params)
    if @answer.save
      flash[:notice] = 'Answer saved'
      redirect_to answers_path
    else
      render action: 'edit'
    end
  end
  
  private
  
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
