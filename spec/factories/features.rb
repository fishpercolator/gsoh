FactoryGirl.define do
  factory :feature do
    name { Faker::Company.name }
    ftype { Faker::Company.profession }
    subtype nil
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end
