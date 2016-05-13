require 'rails_helper'

RSpec.describe Match, type: :model do
  
  let(:user)  { create :user }
  let(:area)  { create :area }
  let(:score) { 50 }
  subject     { Match.new(user: user, area: area, score: score) }

  # We need answers!
  before(:each) do
    @answers = {}
    [:big_lose, :lose, :irrelevant, :win, :big_win].each do |n|
      @answers[n] = create(:importance_answer, user: user, question: create(:importance_question))
      allow(@answers[n]).to receive(:score_area).with(area).and_return(n)
    end
    allow(user).to receive(:answers).and_return(@answers.values)
  end
    
  describe '#good_answers' do
    it 'includes the :win and :big_win' do
      expect(subject.good_answers).to include(@answers[:win], @answers[:big_win])
    end
    it 'does not include the :irrelevant' do
      expect(subject.good_answers).not_to include(@answers[:irrelevant])
    end
    it 'does not include the :lose and :big_lose' do
      expect(subject.good_answers).not_to include(@answers[:big_lose], @answers[:lose])
    end
  end
  
  describe '#bad_answers' do
    it 'includes the :lose and :big_lose' do
      expect(subject.bad_answers).to include(@answers[:lose], @answers[:big_lose])
    end
    it 'does not include the :irrelevant' do
      expect(subject.bad_answers).not_to include(@answers[:irrelevant])
    end
    it 'does not include the :win or :big_win' do
      expect(subject.bad_answers).not_to include(@answers[:win], @answers[:big_win])
    end
  end
end
