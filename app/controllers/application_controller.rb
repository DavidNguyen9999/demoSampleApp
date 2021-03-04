class ApplicationController < ActionController::Base
  #  include SessionsHelper
  #
  #  private
  #
  #  # Confirms a logged-in user.
  #  def logged_in_user
  #    unless logged_in?
  #      store_location
  #      flash[:danger] = "Please log in."
  #      redirect_to login_url
  #    end
  #  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :remember_me, :password_confirmation) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end
end
