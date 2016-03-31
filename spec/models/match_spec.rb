require 'rails_helper'

RSpec.describe Match, type: :model do
  
  let(:user)  { create :user }
  let(:area)  { create :area }
  let(:score) { 50 }
  subject     { Match.new(user: user, area: area, score: score) }

  # We need answers!
  before(:each) do
    @answers = {}
    [:dealbreaker, :lose, :irrelevant, :win].each do |n|
      @answers[n] = create(:importance_answer, user: user, question: create(:importance_question))
      allow(@answers[n]).to receive(:score_area).with(area).and_return(n)
    end
    allow(user).to receive(:answers).and_return(@answers.values)
  end
    
  describe '#good_answers' do
    it 'includes the :win' do
      expect(subject.good_answers).to include(@answers[:win])
    end
    it 'does not include the :irrelevant' do
      expect(subject.good_answers).not_to include(@answers[:irrelevant])
    end
    it 'does not include the :lose and :dealbreaker' do
      expect(subject.good_answers).not_to include(@answers[:dealbreaker], @answers[:lose])
    end
  end
  
  describe '#bad_answers' do
    it 'includes the :lose' do
      expect(subject.bad_answers).to include(@answers[:lose])
    end
    it 'does not include the :irrelevant' do
      expect(subject.bad_answers).not_to include(@answers[:irrelevant])
    end
    it 'does not include the :win' do
      expect(subject.bad_answers).not_to include(@answers[:win])
    end
    it 'does not include the :dealbreaker' do
      expect(subject.bad_answers).not_to include(@answers[:dealbreaker])
    end
  end
  
  describe '#dealbreakers' do
    it 'includes the :dealbreaker' do
      expect(subject.dealbreakers).to include(@answers[:dealbreaker])
    end
    it 'does not include the others' do
      expect(subject.dealbreakers).not_to include(@answers[:win], @answers[:lose], @answers[:irrelevant])
    end
  end
  
end
