require 'osm_query'
require 'ckan'

# This whole thing is a bit of a mess - ideally the city should be stored as
# config (perhaps in a DSL) and this data generated that way.

namespace :gsoh do
  
  CITY_NAME = ENV['CITY'] || 'leeds'
    
  desc 'Regenerate all the features in the DB'
  task :seed_features => [:seed_ckan, :seed_osm, :regenerate_matches]

  task :logger => :environment do
    logger           = Logger.new(STDOUT)
    logger.level     = Logger::INFO
    Rails.logger     = logger
  end
    
  task :seed_osm => :logger do
    City.new(name: CITY_NAME).regenerate_osm!
  end
  
  task :seed_ckan => :logger do
    City.new(name: CITY_NAME).regenerate_ckan!
  end
end
