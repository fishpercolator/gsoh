class Area < ActiveRecord::Base
  serialize :geography
  
  before_save do
    # If the geography was given as a string, run it in a sandbox
    if geography.is_a? String
      self.geography = Shikashi::Sandbox.run(geography)
    end
  end
  
  def features
    Feature.in_geography(geography)
  end
  
  def specific_feature(ftype, subtype: nil)
    features.with_type(ftype, subtype)
  end
  
  def contains?(ftype, subtype: nil)
    specific_feature(ftype, subtype: subtype).any?
  end
  
  # Returns the points of the polygon (currently always a rectangle)
  def polygon
    g = geography
    [[g[:n],g[:w]], [g[:n], g[:e]], [g[:s], g[:e]], [g[:s], g[:w]]]
  end
  
end
