class Feature < ActiveRecord::Base
  acts_as_mappable
  
  scope :with_type,    -> (ftype, subtype=nil) { subtype.present? ? where(ftype: ftype, subtype: subtype) : where(ftype: ftype) }
  scope :in_area,      -> (area) { in_bounds(area.bounds) }

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
  
  # Construct a new feature from a row of NNS data (from Leeds Data Mill)
  def self.from_nns_data(nns)
    latlng = Breasal::EastingNorthing.new(nns.slice(:easting, :northing)).to_wgs84
    new do |f|
      f.ftype = 'nns'
      f.name  = nns[:nameofneighbourhoodnetworkscheme].strip
      f.lat   = latlng[:latitude]
      f.lng   = latlng[:longitude]
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
