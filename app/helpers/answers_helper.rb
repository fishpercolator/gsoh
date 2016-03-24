module AnswersHelper
  def remaining_questions
    current_user.unanswered_questions.count
  end
  # Percentage of the way through answering the questions
  def progress
    (current_user.answers.count * 100) / Question.count
  end
end
