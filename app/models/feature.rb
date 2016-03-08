class Feature < ActiveRecord::Base
  
  # Construct a new feature from an OSM object hash as returned by OSMLeeds
  def self.from_osm(osm)
    new do |f|
      f.send(:from_osm_tags, osm[:tags])
      
      # Pick a node for lat/lng - for ways, just pick one of the corners
      node = osm[:type] == 'way' ? osm[:nodes].compact.first : osm
      if !node
        fail "Argh! What is this: #{osm}"
      end
      f.lat = node[:lat]
      f.lng = node[:lon]
    end
  end
  
  def self.subtypes_for(ftype)
    where(ftype: ftype).select(:subtype).distinct.map(&:subtype).compact.sort
  end
  
  private
  
  def from_osm_tags(tags)
    self.name  = tags[:name]

    # Set ftype
    if tags[:shop]
      self.ftype = 'shop'
    else
      self.ftype = tags[:amenity]
    end
    
    # Set subtype if appropriate
    case ftype
    when 'place_of_worship'
      self.subtype = tags[:religion]
    when 'shop'
      self.subtype = tags[:shop] unless tags[:shop] == 'yes'
    end
  end
  
end
