require 'answer'

FactoryGirl.define do
  factory :answer do
    user nil
    question nil
    subtype nil
    answer 0
    factory :importance_answer, class: 'ImportanceAnswer'
    factory :boolean_answer, class: 'BooleanAnswer'
  end
end
