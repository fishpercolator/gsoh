class Match < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :area
  validates :score, presence: true, numericality: true
  
  def goodness
    case score.to_i
    when 51..100
      :good
    when 50
      :middle
    else
      :bad
    end
  end
  
  def good_answers
    user.answers.select {|a| a.score_area(area) == :win }
  end
  
  def bad_answers
    user.answers.select {|a| a.score_area(area) == :lose }
  end
  
  def dealbreakers
    user.answers.select {|a| a.score_area(area) == :dealbreaker }
  end
  
end
