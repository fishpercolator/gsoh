class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_ga

  private
  
  def user_not_authorized(exception)
    logger.error("Authorization error: user #{current_user&.id} #{exception}")
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:subscribe_to_mailing_list])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
  def set_ga
    gon.ga_tracker = GA.tracker
  end
  
end
