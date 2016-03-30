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
  
  describe '#score_area' do
    let(:area1) { create :area }
    let(:area2) { create :area }
    let(:scores1) { [] }
    let(:scores2) { [] }
    before(:each) do
      allow(subject).to receive(:area_scores).with(area1).and_return(scores1)
      allow(subject).to receive(:area_scores).with(area2).and_return(scores2)
    end
    
    context 'no answers yet' do
      it 'scores 100' do
        expect(subject.score_area area1).to eq(100)
      end
    end

    context 'all wins or irrelevant' do
      let(:scores1) { [:win, :irrelevant, :win, :irrelevant, :irrelevant] }
      it 'scores 100' do
        expect(subject.score_area area1).to eq(100)
      end
    end
    
    context 'both 1 lose, area1 has more wins' do
      let(:scores1) { [:win, :irrelevant, :irrelevant, :lose] }
      let(:scores2) { [:irrelevant, :lose, :irrelevant, :irrelevant] }
      it 'both scores are between 0 and 100' do
        expect(subject.score_area area1).to be_between(0,100)
        expect(subject.score_area area2).to be_between(0,100)
      end
      it 'area1 scores higher than area2' do
        expect(subject.score_area area1).to be > subject.score_area(area2)
      end
    end
    
    context "both 2 loses, but area1 has a dealbreaker" do
      let(:scores1) { [:win, :irrelevant, :lose, :dealbreaker] }
      let(:scores2) { [:win, :irrelevant, :lose, :lose] }
      it 'both scores are between 0 and 100' do
        expect(subject.score_area area1).to be_between(0,100)
        expect(subject.score_area area2).to be_between(0,100)
      end
      it 'area2 scores higher than area1' do
        expect(subject.score_area area2).to be > subject.score_area(area1)
      end
    end
    
    context 'all loses' do
      let(:scores1) { [:lose, :lose, :lose, :dealbreaker] }
      it 'scores 0' do
        expect(subject.score_area area1).to eq(0)
      end
    end
    
    context 'more wins than loses' do
      let(:scores1) { [:win, :win, :lose] }
      it 'scores between 50 and 100' do
        expect(subject.score_area area1).to be_between(50,100)
      end
    end
    
    context 'more loses than wins' do
      let(:scores1) { [:win, :lose, :lose] }
      it 'scores between 0 and 99.9' do
        expect(subject.score_area area1).to be_between(0,99.9)
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
