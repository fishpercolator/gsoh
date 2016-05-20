module AnswersHelper
  def answered
    current_user.answers.count
  end
  # Percentage of the way through answering the questions
  def progress
    (current_user.answers.count * 100) / Question.count
  end
end
