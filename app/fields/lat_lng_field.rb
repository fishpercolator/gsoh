require "administrate/field/base"

class LatLngField < Administrate::Field::Base
  def lat?
    options.fetch(:lat, false)
  end
  
  def lng?
    options.fetch(:lng, false)
  end
  
  def which
    lat? ? :lat : :lng
  end
  
  def initial
    options.fetch(:initial, [53.8003,-1.5519])
  end
  
  def zoom
    options.fetch(:zoom, 11)
  end
  
  def to_s
    data
  end
end
