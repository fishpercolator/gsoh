require 'osm_leeds'

namespace :gsoh do
  
  desc 'Regenerate all the features in the DB'
  task :seed_features => :environment do
    # Obliterate all the existing features (FIXME)
    Feature.destroy_all
    
    leeds = OSMLeeds.new
    %w{pharmacy place_of_worship restaurant pub cafe bank library}.each do |am|
      leeds.query('amenity' => am).each {|osm| Feature.from_osm(osm).save }
    end
    leeds.query('shop' => true).each {|osm| Feature.from_osm(osm).save }
    # FIXME: Do the 'leisure' types
  end
  
end
