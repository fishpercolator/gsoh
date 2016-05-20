class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :campaignable, :omniauth_providers => [:facebook, :twitter, :google_oauth2]
       
  has_many :answers, dependent: :delete_all
  has_many :questions, through: :answers
  has_many :matches, -> { order(score: :desc, id: :asc) }, dependent: :delete_all
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name  = auth.info.name
    end
  end
  
  def display_name
    if name.present?
      name
    else
      email
    end
  end
  
  def unanswered_questions
    Question.where.not(id: questions).order(:id)
  end
  
  def next_unanswered_question_after(id)
    unanswered_questions.where("id > ?", id).first
  end 
  
  def answer_question(question, answer, subtype: nil)
    question.answer(user: self, answer: answer, subtype: subtype).tap do |a|
      a.save!
      questions.reload
    end
  end
  
  # Get the score for an area across all the provided answers.
  def score_area(area)
    scores = area_scores(area)
    return 100 if scores.all? {|s| s == :irrelevant} # perfect match if we know nothing!
    
    # Calculate a "score" based on the ratio of wins to loses
    win_score =  2*scores.count(:big_win)  + scores.count(:win)
    lose_score = 2*scores.count(:big_lose) + scores.count(:lose)
    # 100% would be win_score + lose_score
    # so the score is 1 - (lose_score / win_score+lose_score)
    (1 - (lose_score.to_f / (win_score+lose_score).to_f)) * 100
  end
  
  # Regenerate all the user's matches based on the areas' current scores
  def regenerate_matches!
    Area.eager_load(:area_contained_ftypes).all.each do |area|
      area.regenerate_matches_for!(self)
    end
  end
  
  # Returns true if the user has a password set in the database
  def has_password?
    encrypted_password_was.present?
  end
    
  private
  
  def area_scores(area)
    answers.eager_load(:question).map {|ans| ans.score_area(area) }
  end
  
  def email_required?
    provider != 'twitter'
  end
  
  # Don't require a password if the user is a new user from Oauth but require
  # it when they change their account
  def password_required?
    return false if !persisted? and provider.present?
    super
  end

end
