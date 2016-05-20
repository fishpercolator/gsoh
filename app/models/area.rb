class Area < ActiveRecord::Base
  acts_as_mappable
  
  # Hardcode this for now
  RADIUS = 500
  
  has_many :matches, dependent: :delete_all
  has_and_belongs_to_many :features
  
  # A table that quickly looks up whether an area contains a given ftype
  has_many :area_contained_ftypes, dependent: :delete_all
  
  # Whenever an area is saved, regenerate all features and user matches
  before_save do
    self.features = Feature.within(RADIUS.to_f/1000, units: :kms, origin: self)
    self.regenerate_area_contained_ftypes!
  end
  after_save do
    User.all.each { |u| regenerate_matches_for! u }
  end
  
  def specific_feature(ftype, subtype: nil)
    features.with_type(ftype, subtype)
  end
  
  # Should be called on an area that's preloaded its area_contained_ftypes to
  # prevent a heavy SQL query
  def contains?(ftype, subtype: nil)
    if subtype
      area_contained_ftypes.any? {|f| f.ftype == ftype && f.subtype == subtype }
    else
      area_contained_ftypes.any? {|f| f.ftype == ftype }
    end
  end
  
  # Returns the closest feature of the given type to the centre of the area,
  # whether it's in the area or not
  def closest(ftype)
    Feature.where(ftype: ftype).closest(origin: self).first
  end
  
  def regenerate_matches_for!(user)
    m = Match.find_or_create_by(user: user, area: self)
    m.update!(score: user.score_area(self))
  end
  
  def regenerate_area_contained_ftypes!
    self.area_contained_ftypes = self.features.select(:ftype, :subtype).distinct.map do |f|
      AreaContainedFtype.new(ftype: f.ftype, subtype: f.subtype)
    end
  end
end
