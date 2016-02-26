FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    admin false
    
    factory :admin do
      admin true
    end
  end
end
