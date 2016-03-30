class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  validates_presence_of :type, :user, :question, :answer
  validates_uniqueness_of :question, scope: :user
  validate :question_matches
    
  # Remove subtype from answer if it wasn't asked in the question
  # - we do this instead of validation because the code quickly becomes a
  #   mess otherwise
  before_save do
    if !question.ask_subtype?
      self.subtype = nil
    end
  end
  
  # Make sure a user's matches are regenerated whenever an answer is saved
  after_save do
    user.regenerate_matches!
  end
  
  def self.new_with_type(params)
    Question.find(params[:question_id])&.answer(params)
  end
  
  def matching_question_class
    fail "Abstract!"
  end
  
  def available_subtypes
    Feature.subtypes_for(question.ftype)
  end
  
  # Returns a score between 0 and 100 for a given area in response to this
  # question
  def score_area(area)
    50
  end
  
  # True if the specified area contains the feature referred to by this answer
  def area_contains_feature?(area)
    area.contains?(question.ftype, subtype: subtype)
  end
  
  # The specific features that match this answer for a given area (good or bad)
  def area_matching_features(area)
    area.specific_feature(question.ftype, subtype: subtype)
  end
  
  def to_s
    subtype_str = subtype? ? " (#{subtype})" : ""
    "<Q: #{question.text} A: #{answer}#{subtype_str}>"
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
  
  # If the answer was :irrelevant or :bad then the subtype isn't used - remove it
  before_save do
    if irrelevant? or bad?
      self.subtype = nil
    end
  end
  
  def self.model_name
    Answer.model_name
  end
  
  def matching_question_class
    ImportanceQuestion
  end
  
  def score_area(area)
    contains = area_contains_feature?(area)
    if essential?
      contains ? 100 : 0
    elsif important?
      contains ? 75 : 25
    elsif bad?
      contains ? 25 : 75
    else
      50 # if irrelevant it doesn't matter either way
    end
  end
  
end

class BooleanAnswer < Answer
  enum answer: [:yes, :no]
  
  # If the answer was no, remove the subtype
  before_save do
    if no?
      self.subtype = nil
    end
  end
  
  def self.model_name
    Answer.model_name
  end
  
  def matching_question_class
    BooleanQuestion 
  end
  
  # If the answer is 'no' (you don't care) then subtype should be ignored
  def subtype
    if no?
      nil
    else
      super
    end
  end    
  
  def score_area(area)
    contains = area_contains_feature?(area)
    if yes?
      contains ? 100 : 0
    else
      50 # if it's not important, it's 50 either way
    end
  end
end
