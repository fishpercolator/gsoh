require 'question'

FactoryGirl.define do
  factory :question do
    ftype { %w{church school doctors pub}.sample }
    ask_subtype false
    factory :importance_question, class: 'ImportanceQuestion' do
      text { "How important is it to you to be near a #{ftype}?" }
    end
    factory :boolean_question, class: 'BooleanQuestion' do
      text { "Do you want to be near a #{ftype}?" }
    end
  end
end
