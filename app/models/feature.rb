class Feature < ActiveRecord::Base
  
  scope :in_geography, -> (geography) { where(lat: geography[:s]..geography[:n], lng: geography[:w]..geography[:e]) }
  scope :with_type,    -> (ftype, subtype=nil) { subtype.present? ? where(ftype: ftype, subtype: subtype) : where(ftype: ftype) }
    
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
    where(ftype: ftype).distinct.pluck(:subtype).compact.sort
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
