class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    # Also add the answer to the created user
    if answer_params[:answer]
      self.resource.answers << Answer.new_with_type(answer_params[:answer])
    end
  end
  
  protected
  
  def after_sign_up_path_for(resource)
    new_answer_path
  end
    
  def update_resource(resource, params)
    if resource.has_password?
      resource.update_with_password(params)
    else
      resource.update_attributes(params)
    end
  ensure
    resource.clean_up_passwords
  end
  
  private
  
  def answer_params
    params.permit(:answer => [:question_id, :user_id, :answer])
  end
  
end
