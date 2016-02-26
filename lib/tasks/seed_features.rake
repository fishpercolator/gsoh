require 'osm_leeds'

namespace :gsoh do
  
  desc 'Regenerate all the features in the DB'
  task :seed_features => :environment do
    # Obliterate all the existing features
    Feature.destroy_all
    
    leeds = OSMLeeds.new
    leeds.query('amenity' => 'pharmacy').each do |ph|
      Feature.create(name: (ph[:tags] && ph[:tags][:name]), ftype: 'pharmacy', lat: ph[:lat], lng: ph[:lon])
    end
    leeds.query('amenity' => 'place_of_worship').each do |r|
      Feature.create(name: (r[:tags] && r[:tags][:name]), ftype: 'place_of_worship', subtype: (r[:tags] && r[:tags][:religion]), lat: r[:lat], lng: r[:lon])
    end
  end
  
end
