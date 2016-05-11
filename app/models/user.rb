class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook, :twitter]
       
  has_many :answers
  has_many :questions, through: :answers
  has_many :matches, -> { order(score: :desc) }, dependent: :delete_all
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
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
    return 100 if scores.empty? # perfect match if we know nothing!
    return 0 if scores.any? {|s| s == :dealbreaker} # always 0 if area contains a dealbreaker
    
    # The "loss weight" is the fraction of loses + 2*dealbreakers
    loss_weight = scores.count(:lose).to_f / scores.count
    
    # The "win weight" is the fraction of non-wins (i.e. more wins lowers the weight)
    win_weight = (scores.count - scores.count(:win)).to_f / scores.count
    
    # Multiplying the two weights and subtracting them from 1 should give us our percentage
    (1 - loss_weight * win_weight) * 100
  end
  
  # Regenerate all the user's matches based on the areas' current scores
  def regenerate_matches!
    Area.all.each do |area|
      m = Match.find_or_create_by(user: self, area: area)
      m.update!(score: score_area(area))
    end
  end
  
  private
  
  def area_scores(area)
    answers.map {|ans| ans.score_area(area) }
  end
  
end
