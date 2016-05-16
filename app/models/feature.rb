class Feature < ActiveRecord::Base
  validates :ftype, presence: true
  acts_as_mappable
  
  scope :with_type,    -> (ftype, subtype=nil) { subtype.present? ? where(ftype: ftype, subtype: subtype) : where(ftype: ftype) }
  scope :in_area,      -> (area) { in_bounds(area.bounds) }
  
  def self.subtypes_for(ftype)
    where(ftype: ftype).distinct.pluck(:subtype).compact.sort
  end
end
