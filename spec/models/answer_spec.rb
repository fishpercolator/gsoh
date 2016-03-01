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
  
end
