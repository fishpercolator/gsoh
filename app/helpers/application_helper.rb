module ApplicationHelper
  
  def errors_for(obj)
    if obj.errors.any?
      render partial: 'application/errors_for', object: obj
    end
  end
  
end
