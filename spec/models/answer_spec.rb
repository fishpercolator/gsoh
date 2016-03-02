require 'rails_helper'

RSpec.describe Answer, type: :model do
  
  let(:question) { create :importance_question }
  let(:user)     { create :user }
  subject        { create :importance_answer, question: question, user: user }
  
  describe '.new_with_type' do
    it 'casts immediately' do
      expect(Answer.new_with_type(question_id: question.id)).to be_an(ImportanceAnswer)
    end
  end
  
  describe '#available_subtypes' do
    before(:each) do
      %w{foo bar baz qux}.each do |subtype|
        create :feature, ftype: question.ftype, subtype: subtype
      end
      # And create some ones that shouldn't be checked
      %w{one two three}.each do |subtype|
        create :feature, ftype: 'other', subtype: subtype
      end
    end
    it 'finds all the subtypes in alphabetical order' do
      expect(subject.available_subtypes).to eq(%w{bar baz foo qux})
    end
  end
  
  describe 'subtype deletion' do
    context 'question with ask_subtype=true' do
      context ImportanceAnswer do
        let(:question) { create :importance_question, ask_subtype: true }
        it 'deletes subtype for answer=irrelevant' do
          a = create :importance_answer, question: question, user: user, answer: :irrelevant, subtype: 'foo'
          expect(a.subtype).to be nil
        end
        it 'does not delete subtype for answer=essential' do
          a = create :importance_answer, question: question, user: user, answer: :essential, subtype: 'foo'
          expect(a.subtype).to eq('foo')
        end
        context 'question with ask_subtype=false' do
          let(:question) { create :importance_question, ask_subtype: false }
          it 'deletes subtype even if answer=essential' do
            a = create :importance_answer, question: question, user: user, answer: :essential, subtype: 'foo'
            expect(a.subtype).to be nil
          end
        end
      end
      context BooleanAnswer do
        let(:question) { create :boolean_question, ask_subtype: true }
        it 'deletes subtype for answer=no' do
          a = create :boolean_answer, question: question, user: user, answer: :no, subtype: 'foo'
          expect(a.subtype).to be nil
        end
        it 'does not delete subtype for answer=yes' do
          a = create :boolean_answer, question: question, user: user, answer: :yes, subtype: 'foo'
          expect(a.subtype).to eq('foo')
        end
      end
    end
  end
end
