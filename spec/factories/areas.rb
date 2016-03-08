FactoryGirl.define do
  factory :area do
    name { Faker::Address.city }
    geography do
      lats = Array.new(2) { Faker::Address.latitude.to_f }.sort
      lngs = Array.new(2) { Faker::Address.longitude.to_f }.sort
      {n: lats[1], s: lats[0], e: lngs[1], w: lngs[0]}
    end
    
    # Create an area with n_features random features of the given types
    # create :area_with_features, ftypes: %w{school pub}, n_features: 4
    factory :area_with_features do
      transient do
        ftypes %w{church school doctors pub}
        n_features 2
      end
      after(:create) do |area, evaluator|
        avg_lat = (area.geography[:n] + area.geography[:s]) / 2
        avg_lng = (area.geography[:e] + area.geography[:w]) / 2
        guaranteed = evaluator.ftypes.clone # guarantee at least one of each type
        evaluator.n_features.times do
          create :feature, lat: avg_lat, lng: avg_lng, ftype: guaranteed.shift || evaluator.ftypes.sample
        end
      end
    end
  end
end
