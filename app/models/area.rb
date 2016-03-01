class Area < ActiveRecord::Base
  serialize :geography
  
  def features
    Feature.where(lat: geography[:s]..geography[:n], lng: geography[:w]..geography[:e])
  end
  
  def contains?(ftype, subtype: nil)
    conditions = {ftype: ftype}.tap do |c|
      c[:subtype] = subtype if subtype
    end
    features.where(conditions).any?
  end
  
end
