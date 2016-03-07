FactoryGirl.define do
  factory :feature do
    name { Faker::Company.name }
    ftype { %w{church school doctors pub}.sample }
    subtype nil
    lat { Faker::Address.latitude.to_f }
    lng { Faker::Address.longitude.to_f }
  end
end
