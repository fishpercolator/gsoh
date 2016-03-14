# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    before_filter :authenticate_admin

    def authenticate_admin
      authorize :admin, :show?
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
    
    private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
    
    # Temporary to get around collision between method name in administrate
    # 0.1.4 and pundit
    def resource_params
      params.require(resource_name).permit(dashboard.permitted_attributes)
    end

  end
end
