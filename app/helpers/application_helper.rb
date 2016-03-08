module ApplicationHelper
  
  def errors_for(obj)
    if obj.errors.any?
      render partial: 'application/errors_for', object: obj
    end
  end
  
  def feature_name_and_subtype(feature)
    if feature.subtype?
      "#{feature.name} (#{t feature.subtype})".html_safe
    else
      feature.name
    end
  end
  
end
