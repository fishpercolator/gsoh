FactoryGirl.define do
  factory :area do
    name { Faker::Address.city }
    geography do
      lats = Array.new(2) { Faker::Address.latitude }.sort
      lngs = Array.new(2) { Faker::Address.longitude }.sort
      {n: lats[1], s: lats[0], e: lngs[1], w: lngs[0]}
    end
  end
end
