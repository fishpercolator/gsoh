class Area < ActiveRecord::Base
  serialize :geography
  
  before_save do
    # If the geography was given as a string, run it in a sandbox
    if geography.is_a? String
      self.geography = Shikashi::Sandbox.run(geography)
    end
  end
  
  def features
    Feature.where(lat: geography[:s]..geography[:n], lng: geography[:w]..geography[:e])
  end
  
  def specific_feature(ftype, subtype: nil)
    conditions = {ftype: ftype}.tap do |c|
      c[:subtype] = subtype if subtype.present? # assume blank is nil
    end
    features.where(conditions)
  end
  
  def contains?(ftype, subtype: nil)
    specific_feature(ftype, subtype: subtype).any?
  end
  
end
