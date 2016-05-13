require 'rails_helper'

RSpec.describe Question, type: :model do
  
  subject { create :importance_question }
  let(:user) { create :user }
  
  describe '#answer_from' do
    context 'user has answered' do
      let!(:answer) { user.answer_question(subject, :important) }
      it 'returns the answer' do
        a = subject.answer_from(user)
        expect(a).to be_an(ImportanceAnswer)
        expect(a.answer).to eq('important')
        expect(a.new_record?).to be false
      end
    end
    context 'user has not answered' do
      it 'returns an unsaved answer' do
        a = subject.answer_from(user)
        expect(a).to be_an(ImportanceAnswer)
        expect(a.new_record?).to be true
      end
    end
  end
  
  describe '#available_answers' do
    it 'matches the list of answers on the appropriate class' do
      expect(subject.available_answers).to eq(ImportanceAnswer.answers)
    end
  end
  
end
