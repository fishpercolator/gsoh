class Area < ActiveRecord::Base
  serialize :geography
  
  before_save do
    # If the geography was given as a string, run it in a sandbox
    if geography.is_a? String
      self.geography = Shikashi::Sandbox.run(geography)
    end
  end
  
  # Whenever an area is saved, regenerate all user matches
  after_save do
    User.all.each(&:regenerate_matches!)
  end
  
  def features
    Feature.in_area(self)
  end
  
  def specific_feature(ftype, subtype: nil)
    features.with_type(ftype, subtype)
  end
  
  def contains?(ftype, subtype: nil)
    specific_feature(ftype, subtype: subtype).any?
  end
  
  # Returns the centre of the area as a lat/lng array
  def centre
    lat = geography.values_at(:n,:s).sum / 2
    lng = geography.values_at(:w,:e).sum / 2
    [lat, lng]
  end
  
  # Returns the closest feature of the given type to the centre of the area,
  # whether it's in the area or not
  def closest(ftype)
    Feature.where(ftype: ftype).closest(origin: self.centre).first
  end
  
  # Returns the points of the polygon (currently always a rectangle)
  def polygon
    g = geography
    [[g[:n],g[:w]], [g[:n], g[:e]], [g[:s], g[:e]], [g[:s], g[:w]]]
  end
  
  # Returns the bounds in Geokit format
  def bounds
    sw = Geokit::LatLng.new *geography.values_at(:s,:w)
    ne = Geokit::LatLng.new *geography.values_at(:n,:e)
    Geokit::Bounds.new(sw, ne)
  end
  
end
