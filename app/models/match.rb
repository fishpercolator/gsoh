class Match
  include ActiveModel::Model
  
  attr_accessor :user, :area, :score
  
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
    user.answers.select {|a| a.score_area(area) > 50 }
  end
  
  def bad_answers
    user.answers.select {|a| a.score_area(area) < 50 }
  end
  
end
