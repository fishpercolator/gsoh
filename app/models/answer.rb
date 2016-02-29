class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  validates_presence_of :type, :user, :question, :answer
  validates_presence_of :subtype, if:     -> { question.ask_subtype }
  validates_absence_of  :subtype, unless: -> { question.ask_subtype }
  validate :question_matches
  
  def matching_question_class
    fail "Abstract!"
  end
  
  private
  
  def question_matches
    unless question.is_a? matching_question_class
      errors.add(:question, "must be #{matching_question_class}")
    end
  end
end

class ImportanceAnswer < Answer
  enum answer: [:essential, :important, :irrelevant, :bad]
  
  def matching_question_class
    ImportanceQuestion
  end
end

class BooleanAnswer < Answer
  enum answer: [:yes, :no]
  
  def matching_question_class
    BooleanQuestion 
  end
end
