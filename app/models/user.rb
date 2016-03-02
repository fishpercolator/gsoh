class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
       
  has_many :answers
  has_many :questions, through: :answers
  
  def unanswered_questions
    Question.where.not(id: questions)
  end
  
  def answer_question(question, answer, subtype: nil)
    question.answer(user: self, answer: answer, subtype: subtype).tap do |a|
      a.save!
      questions.reload
    end
  end
  
  # Get the average score for an area across all the provided answers
  def score_area(area)
    50 if answers.count == 0 # avoid divzero
    answers.map {|ans| ans.score_area(area) }.sum.to_f / answers.count
  end
  
end
