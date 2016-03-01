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
  
  # Returns a user's answer to this question or a blank answer object if unanswered
  def answer_from(user)
    user.answers.where(question_id: self).first || 
      matching_answer_class.new do |answer|
        answer.question = self
      end
  end
  
  def available_answers
    matching_answer_class.answers
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
