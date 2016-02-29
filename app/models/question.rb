class Question < ActiveRecord::Base
  validates_presence_of :type, :text, :ftype
end

class ImportanceQuestion < Question
  # Disable subclass routing
  def self.model_name
    Question.model_name
  end
end

class BooleanQuestion < Question
  def self.model_name
    Question.model_name
  end
end
