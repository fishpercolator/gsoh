FactoryGirl.define do
  factory :area do
    name { Faker::Address.city }
    lat  { Faker::Address.latitude.to_f }
    lng  { Faker::Address.longitude.to_f }
    
    trait :central_leeds do
      lat 53.7990
      lng -1.5457
    end
    
    # Create an area with n_features random features of the given types
    # create :area_with_features, ftypes: %w{school pub}, n_features: 4
    factory :area_with_features do
      transient do
        ftypes %w{church school doctors pub}
        n_features 2
      end
      after(:create) do |area, evaluator|
        guaranteed = evaluator.ftypes.clone # guarantee at least one of each type
        evaluator.n_features.times do
          create :feature, lat: area.lat, lng: area.lng, ftype: guaranteed.shift || evaluator.ftypes.sample
        end
        # Create a neighbourhood network inside the neighbourhood
        create :feature, lat: area.lat, lng: area.lng, ftype: 'nns'
        
        # And update the features in the area
        area.save!
      end
    end
  end
end
