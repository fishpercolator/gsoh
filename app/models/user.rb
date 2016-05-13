class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook, :twitter]
       
  has_many :answers
  has_many :questions, through: :answers
  has_many :matches, -> { order(score: :desc) }, dependent: :delete_all
  
  attr_accessor :subscribe_to_mailing_list
  
  before_save do
    subscribe_to_mailing_list! if subscribe_to_mailing_list?
  end
  
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
      area.regenerate_matches_for!(self)
    end
  end
  
  # Returns true if the user has a password set in the database
  def has_password?
    encrypted_password_was.present?
  end
  
  # Returns true if subscribe_to_mailing_list is present and not 0/'0'
  # (checkbox off values)
  def subscribe_to_mailing_list?
    subscribe_to_mailing_list.present? &&
    subscribe_to_mailing_list.to_s != '0'
  end
      
  private
  
  def area_scores(area)
    answers.map {|ans| ans.score_area(area) }
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
  
  # Subscribes the user to the mailing list. Sets the status to pending (i.e.
  # they need to click the link in the email) for politeness.
  def subscribe_to_mailing_list!
    mailing_list.members(email_md5).upsert(body: {
      email_address: email,
      status: 'pending'
    })
    self.subscribe_to_mailing_list = nil
  end
  
  # Get the default mailing list as a Gibbon list or nil if no list_id has been set
  def mailing_list
    list_id = Rails.application.secrets.mailchimp_list_id
    return nil unless list_id.present?
    Gibbon::Request.new.lists(list_id)
  end
  
  # Get the email as an MD5 hash for Mailchimp
  def email_md5
    Digest::MD5.hexdigest email
  end
    
end
