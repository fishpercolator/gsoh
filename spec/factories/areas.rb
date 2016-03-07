FactoryGirl.define do
  factory :area do
    name { Faker::Address.city }
    geography do
      lats = Array.new(2) { Faker::Address.latitude.to_f }.sort
      lngs = Array.new(2) { Faker::Address.longitude.to_f }.sort
      {n: lats[1], s: lats[0], e: lngs[1], w: lngs[0]}
    end
    factory :area_with_features do
      after(:create) do |area|
        avg_lat = (area.geography[:n] + area.geography[:s]) / 2
        avg_lng = (area.geography[:e] + area.geography[:w]) / 2
        2.times { create :feature, lat: avg_lat, lng: avg_lng }
      end
    end
  end
end
