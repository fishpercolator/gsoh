FactoryGirl.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password 'password'
    password_confirmation 'password'
    admin false
    
    factory :admin do
      admin true
    end
  end
end
