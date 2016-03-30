require 'osm_leeds'
require 'ckan'

# This whole thing is a bit of a mess - ideally the city should be stored as
# config (perhaps in a DSL) and this data generated that way.

namespace :gsoh do
  
  desc 'Regenerate all the features in the DB'
  task :seed_features => [:destroy_all_features, :seed_nnses, :seed_changing_places, :seed_osm, :regenerate_matches]

  task :destroy_all_features => :environment do
    # Obliterate all the existing features (FIXME)
    Feature.destroy_all
  end
    
  task :seed_osm => :environment do
    leeds = OSMLeeds.new
    OSM_TYPES = {
      'pharmacy'         => 'amenity',
      'doctors'          => 'amenity',
      'place_of_worship' => 'amenity',
      'restaurant'       => 'amenity',
      'pub'              => 'amenity',
      'cafe'             => 'amenity',
      'bank'             => 'amenity',
      'library'          => 'amenity',
      'shop'             => true,
      'sports_centre'    => 'leisure',
      'bus_stop'         => 'highway',
    }
    OSM_TYPES.each do |ftype, tagname|
      puts "Finding #{ftype}:"
      query = case tagname
      when String
        {tagname => ftype}
      else
        # E.g. shop where the ftype is the tag itself
        {ftype => true}
      end
      leeds.query(query).each {|osm| Feature.from_osm(osm).save }
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
