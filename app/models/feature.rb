class Feature < ActiveRecord::Base
  
  # Construct a new feature from an OSM object hash
  def self.from_osm(osm)
    new do |f|
      f.from_osm_tags osm[:tags]
      
      # Pick a node for lat/lng - for ways, just pick one of the corners
      node = osm[:type] == 'way' ? osm[:nodes].first : osm
      f.lat = node[:lat]
      f.lng = node[:lon]
    end
  end
  
  def from_osm_tags(tags)
    self.ftype = tags[:amenity] # Only works for amenities right now
    self.name  = tags[:name]
    # Special things on a per-type basis
    case ftype
    when 'place_of_worship'
      self.subtype = tags[:religion]
    end
  end
  
end
