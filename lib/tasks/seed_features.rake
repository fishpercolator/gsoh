require 'osm_query'
require 'ckan'

# This whole thing is a bit of a mess - ideally the city should be stored as
# config (perhaps in a DSL) and this data generated that way.

namespace :gsoh do
  
  CITY_NAME = ENV['CITY'] || 'leeds'
    
  desc 'Regenerate all the features in the DB'
  task :seed_features => [:seed_nnses, :seed_changing_places, :seed_osm, :regenerate_matches]

  task :logger => :environment do
    logger           = Logger.new(STDOUT)
    logger.level     = Logger::INFO
    Rails.logger     = logger
  end
    
  task :seed_osm => :logger do
    City.new(name: CITY_NAME).regenerate_osm!
  end
  
  task :seed_nnses => :environment do
    puts "Finding nns:"
    nnses = CKAN::Package.find(name: 'neighbourhood-network-schemes').first.resources.first.content_csv
    nnses.each do |nns|
      Feature.from_nns_data(nns.to_h).save
    end
  end
  
  task :seed_changing_places => :environment do
    puts "Finding changing_place:"
    changing_places = CKAN::Package.find(name: 'changing-places-toilets-in-leeds').first.resources.first.content_csv
    changing_places.each do |cp|
      Feature.from_changing_place_data(cp.to_h).save
    end
  end
  
end
