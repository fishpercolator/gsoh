class Area < ActiveRecord::Base
  acts_as_mappable
  
  # Hardcode this for now
  RADIUS = 750
  
  has_many :matches, dependent: :delete_all
  
  # Whenever an area is saved, regenerate all user matches
  after_save do
    User.all.each(&:regenerate_matches!)
  end
  
  def features
    Feature.within(RADIUS.to_f/1000, units: :kms, origin: self)
  end
  
  def specific_feature(ftype, subtype: nil)
    features.with_type(ftype, subtype)
  end
  
  def contains?(ftype, subtype: nil)
    specific_feature(ftype, subtype: subtype).any?
  end
  
  # Returns the closest feature of the given type to the centre of the area,
  # whether it's in the area or not
  def closest(ftype)
    Feature.where(ftype: ftype).closest(origin: self).first
  end
  
end
