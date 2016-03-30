require 'rails_helper'

RSpec.describe User, type: :model do
  
  subject { create :user }
  
  context 'when questions exist' do
    before(:each) do
      # Create 20 questions of random types
      20.times {create [:importance_question, :boolean_question].sample}
    end
    context 'when none answered' do
      describe '#questions' do
        it { expect(subject.questions).to be_empty }
      end
    
      describe '#unanswered_questions' do
        it { expect(subject.unanswered_questions).to have(20).items}
      end
      
      describe '#next_unanswered_question_after' do
        it 'follows in sequence' do
          q5, q6 = subject.unanswered_questions.values_at(5,6)
          expect(subject.next_unanswered_question_after(q5.id)).to eq(q6)
        end
      end
      
      describe '#answer_question' do
        # Create a new :importance_question so now there are 21
        let!(:question) { create :importance_question }
        it 'creates an ImportanceAnswer' do
          expect{subject.answer_question(question, :essential)}.to change{Answer.count}.from(0).to(1)
        end        
        it 'moves a question from unanswered_questions to questions' do
          expect(subject.questions).not_to include(question)
          expect(subject.unanswered_questions).to include(question)
          subject.answer_question(question, :essential)
          expect(subject.questions).to include(question)
          expect(subject.unanswered_questions).not_to include(question)
        end
        it 'has the right answer' do
          subject.answer_question(question, :essential)
          expect(subject.answers).to have(1).item
          a = subject.answers.first
          expect(a).to be_an(ImportanceAnswer)
          expect(a.essential?).to be true
          expect(a.bad?).to be false
          expect(a.question).to eq question
        end
        it 'allows subtype answer but deletes it' do
          expect{subject.answer_question(question, :essential, subtype: 'christian')}.not_to raise_error
          expect(subject.answers.first.subtype).to be nil
        end
        it 'refuses a bad enum answer' do
          expect{subject.answer_question(question, :yes)}.to raise_error(/'yes' is not a valid answer/)
        end
        it 'returns the answer' do
          expect(subject.answer_question(question, :essential)).to be_an(ImportanceAnswer)
        end
        context 'with subtype question' do
          let!(:question) { create :boolean_question, ask_subtype: true }
          it 'stores the answer' do
            subject.answer_question(question, :yes, subtype: 'christian')
            expect(subject.answers.first.subtype).to eq('christian')
          end
        end
      end
    end
  end
  
  context 'area scores' do
    let(:area) { create :area }
    before(:each) do
      # Create some questions and answers from this user and make up scores for them
      answers = 25.times.map { create :importance_answer, question: create(:importance_question), user: subject }
      @scores = answers.map do |answer|
        [0, 25, 50, 75, 100].sample.tap do |score|
          allow(answer).to receive(:score_area).with(area).and_return(score)
        end
      end
      allow(subject).to receive(:answers).and_return(answers)
    end
    describe '#score_area' do
      it 'scores the average of all the answer scores' do
        expect(subject.score_area(area)).to eq(@scores.sum.to_f / 25)
      end
    end
  end
  
  context 'no answers at all' do
    let(:area) { create :area }
    describe '#score_area' do
      it 'returns 50' do
        expect(subject.score_area(area)).to eq(50)
      end
    end
  end
  
  describe '#regenerate_matches!' do
    before(:each) do
      [12.0, 45.0, 78.0, 16.0].each do |score|
        area = create :area
        allow(subject).to receive(:score_area).with(area).and_return(score)
      end
    end
    it 'returns the right number of results' do
      subject.regenerate_matches!
      expect(subject.matches).to have(4).items
    end
    it 'returns a scope of Match objects' do
      subject.regenerate_matches!
      expect(subject.matches.first).to be_a(Match)
    end
    it 'returns the scores in the right order' do
      subject.regenerate_matches!
      expect(subject.matches.map(&:score)).to eq([78.0, 45.0, 16.0, 12.0])
    end
  end
  
end
