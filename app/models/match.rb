class Match
  include ActiveModel::Model
  
  attr_accessor :user, :area, :score
  
  def good_answers
    user.answers.select {|a| a.score_area(area) > 50 }
  end
  
  def bad_answers
    user.answers.select {|a| a.score_area(area) < 50 }
  end
  
end
