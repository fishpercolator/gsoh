require 'osm_query'
require 'ckan'

# This whole thing is a bit of a mess - ideally the city should be stored as
# config (perhaps in a DSL) and this data generated that way.

namespace :gsoh do
  
  BORDER = {n: 53.9458558, e: -1.2903452, s: 53.6983747, w: -1.8003617}
  
  desc 'Regenerate all the features in the DB'
  task :seed_features => [:destroy_all_features, :seed_nnses, :seed_changing_places, :seed_osm, :regenerate_matches]

  task :destroy_all_features => :environment do
    # Obliterate all the existing features (FIXME)
    puts "Destroying existing features (FIXME)..."
    Feature.destroy_all
  end
  
  task :seed_osm => :environment do
    leeds = OSMQuery.new(BORDER)
    leeds.all_types.each do |ftype|
      puts "Finding #{ftype}:"
      leeds.query_type(ftype).each {|osm| Feature.from_osm(osm).save }
    end
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
