class ApplicationController < ActionController::Base

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected 

  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email,
													:password, :password_confirmation) }
  end

  private

  def authenticate_admin!
    unless current_user 
      redirect_to new_user_session_path, notice: "You need to sign in before continuing."
    else
      unless current_user.admin?
        redirect_to root_path
      end
    end
  end
end
