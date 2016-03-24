require 'osm_leeds'
require 'ckan'

namespace :gsoh do
  
  desc 'Regenerate all the features in the DB'
  task :seed_features => [:destroy_all_features, :seed_nnses, :seed_osm]

  task :destroy_all_features => :environment do
    # Obliterate all the existing features (FIXME)
    Feature.destroy_all
  end
    
  task :seed_osm => :environment do
    leeds = OSMLeeds.new
    %w{pharmacy place_of_worship restaurant pub cafe bank library}.each do |am|
      leeds.query('amenity' => am).each {|osm| Feature.from_osm(osm).save }
    end
    leeds.query('shop' => true).each {|osm| Feature.from_osm(osm).save }
    # FIXME: Do the 'leisure' types
  end
  
  task :seed_nnses => :environment do    
    nnses = CKAN::Package.find(name: 'neighbourhood-network-schemes').first.resources.first.content_csv
    nnses.each do |nns|
      Feature.from_nns_data(nns.to_h).save
    end
  end
  
end
