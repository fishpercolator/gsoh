class Area < ActiveRecord::Base
  serialize :geography
  
  def features
    Feature.where(lat: geography[:s]..geography[:n], lng: geography[:w]..geography[:e])
  end
  
end
