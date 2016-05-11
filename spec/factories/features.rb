FactoryGirl.define do
  factory :feature do
    name { Faker::Company.name }
    ftype { %w{church school doctors pub}.sample }
    subtype nil
    lat { Faker::Address.latitude.to_f }
    lng { Faker::Address.longitude.to_f }
    trait :in_city_centre do
      lat 53.7955
      lng -1.5413
    end
    trait :also_in_city_centre do
      lat 53.7962
      lng -1.5509
    end
    trait :outside_city_centre do
      lat 53.7863
      lng -1.5645
    end
    trait :further_outside_city_centre do
      lat 53.8263
      lng -1.5421
    end
  end
end
