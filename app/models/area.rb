class Area < ActiveRecord::Base
  acts_as_mappable
  
  # Hardcode this for now
  RADIUS = 500
  
  has_many :matches, dependent: :delete_all
  has_and_belongs_to_many :features
  
  # Whenever an area is saved, regenerate all features and user matches
  before_save do
    self.features = Feature.within(RADIUS.to_f/1000, units: :kms, origin: self)
  end
  after_save do
    User.all.each { |u| regenerate_matches_for! u }
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
  
  def regenerate_matches_for!(user)
    m = Match.find_or_create_by(user: user, area: self)
    m.update!(score: user.score_area(self))
  end
end
