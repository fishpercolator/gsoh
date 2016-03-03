require 'rails_helper'

RSpec.describe Match, type: :model do
  
  let(:user)  { create :user }
  let(:area)  { create :area }
  let(:score) { 50 }
  subject     { Match.new(user: user, area: area, score: score) }

  # We need answers!
  before(:each) do
    @answers = {}
    [0, 25, 50, 75, 100].each do |n|
      @answers[n] = create(:importance_answer, user: user, question: create(:importance_question))
      allow(@answers[n]).to receive(:score_area).with(area).and_return(n)
    end
    allow(user).to receive(:answers).and_return(@answers.values)
  end
    
  describe '#good_answers' do
    it 'includes the 75 and 100' do
      expect(subject.good_answers).to include(@answers[75], @answers[100])
    end
    it 'does not include the 50' do
      expect(subject.good_answers).not_to include(@answers[50])
    end
    it 'does not include the 0 and 25' do
      expect(subject.good_answers).not_to include(@answers[0], @answers[25])
    end
  end
  
  describe '#bad_answers' do
    it 'includes the 0 and 25' do
      expect(subject.bad_answers).to include(@answers[0], @answers[25])
    end
    it 'does not include the 50' do
      expect(subject.bad_answers).not_to include(@answers[50])
    end
    it 'does not include the 75 and 100' do
      expect(subject.bad_answers).not_to include(@answers[75], @answers[100])
    end
  end
  
end
