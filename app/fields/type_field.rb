require "administrate/field/base"

class TypeField < Administrate::Field::Base
  def to_s
    data
  end
  
  def choices
    options[:class]&.subclasses.map(&:to_s)
  end
  
end
