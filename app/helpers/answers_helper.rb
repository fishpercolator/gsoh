module AnswersHelper
  def remaining_questions
    current_user.unanswered_questions.count
  end
end
