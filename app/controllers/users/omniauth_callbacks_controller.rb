class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      flash[:error] = "Error signing in with Facebook: #{@user.errors.full_messages}"
      redirect_to new_user_session_url
    end
  end
  
  def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      flash[:error] = "Error signing in with Twitter: #{@user.errors.full_messages}"
      redirect_to new_user_session_url
    end
  end

  def failure
    redirect_to root_path
  end
end
