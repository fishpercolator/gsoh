require 'rails_helper'

RSpec.describe Question, type: :model do
  
  subject { create :importance_question }
  let(:user) { create :user }
  
  describe '#answer_from' do
    context 'user has answered' do
      let!(:answer) { user.answer_question(subject, :essential) }
      it 'returns the answer' do
        a = subject.answer_from(user)
        expect(a).to be_an(ImportanceAnswer)
        expect(a.answer).to eq('essential')
      end
    end
    context 'user has not answered' do
      it 'returns nil' do
        expect(subject.answer_from(user)).to be nil
      end
    end
  end
  
end
