class Question < ActiveRecord::Base
  validates_presence_of :type, :text, :ftype
  
  has_many :answers
  has_many :users, through: :answers
  
  # Construct an answer for this question
  def answer(params)
    matching_answer_class.new(params.merge(question: self))
  end
  
  def matching_answer_class
    fail "Abstract!"
  end
end

class ImportanceQuestion < Question
  # Disable subclass routing
  def self.model_name
    Question.model_name
  end
  def matching_answer_class
    ImportanceAnswer
  end
end

class BooleanQuestion < Question
  def self.model_name
    Question.model_name
  end
  def matching_answer_class
    BooleanAnswer
  end
end
