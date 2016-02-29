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
        it 'fails to allow subtype answer' do
          expect{subject.answer_question(question, :essential, subtype: 'christian')}.to raise_error(/Subtype must be blank/)
        end
        it 'refuses a bad enum answer' do
          expect{subject.answer_question(question, :yes)}.to raise_error(/'yes' is not a valid answer/)
        end
        context 'with subtype question' do
          let!(:question) { create :boolean_question, ask_subtype: true }
          it 'requires subtype answer' do
            expect{subject.answer_question(question, :yes)}.to raise_error(/Subtype can't be blank/)
          end
          it 'stores the answer' do
            subject.answer_question(question, :yes, subtype: 'christian')
            expect(subject.answers.first.subtype).to eq('christian')
          end
        end
      end
    end
  end
  
end
