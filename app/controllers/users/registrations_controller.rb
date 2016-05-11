class Users::RegistrationsController < Devise::RegistrationsController
  def update_resource(resource, params)
    if resource.has_password?
      resource.update_with_password(params)
    else
      resource.update_attributes(params)
    end
  ensure
    resource.clean_up_passwords
  end
end
