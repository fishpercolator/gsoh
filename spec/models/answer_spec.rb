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
  
  # This also implicitly tests the #area_contains_feature? method by stubbing the already-specced
  # Area#contains? instead of that method.
  describe '#score_area' do
    let(:area)   { create :area }
    let(:answer) { self.class.description } # let the answer be the context name
    let(:type)   { :importance_answer }
    subject { create(type, question: question, user: user, answer: answer).score_area(area) }
    context 'area contains feature' do
      before(:each) do
        allow(area).to receive(:contains?).with(question.ftype, subtype: nil).and_return(true)
      end
      context ImportanceAnswer do
        context :essential do
          it { is_expected.to eq(:win) }
        end
        context :important do
          it { is_expected.to eq(:win) }
        end
        context :irrelevant do
          it { is_expected.to eq(:irrelevant) }
        end
        context :bad do
          it { is_expected.to eq(:lose) }
        end
      end
      context BooleanAnswer do
        let(:question) { create :boolean_question }
        let(:type)     { :boolean_answer }
        context :yes do
          it { is_expected.to eq(:win) }
        end
        context :no do
          it { is_expected.to eq(:irrelevant) }
        end
      end
    end
    context 'area does not contain feature' do
      before(:each) do
        allow(area).to receive(:contains?).with(question.ftype, subtype: nil).and_return(false)
      end
      context ImportanceAnswer do
        context :essential do
          it { is_expected.to eq(:dealbreaker) }
        end
        context :important do
          it { is_expected.to eq(:lose) }
        end
        context :irrelevant do
          it { is_expected.to eq(:irrelevant) }
        end
        context :bad do
          it { is_expected.to eq(:win) }
        end
      end
      context BooleanAnswer do
        let(:question) { create :boolean_question }
        let(:type)     { :boolean_answer }
        context :yes do
          it { is_expected.to eq(:lose) }
        end
        context :no do
          it { is_expected.to eq(:irrelevant) }
        end
      end
    end
  end
  
end
