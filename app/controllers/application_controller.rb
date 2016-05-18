class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_company, :current_user, :user_signed_in?

  before_action :authenticate_user!

  def current_company
    @current_company ||= current_user.company
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    allow_non_signed_in_controllers = %w(users/sessions users/registrations)
    if !user_signed_in? && !params[:controller].in?(allow_non_signed_in_controllers)
      redirect_to new_users_session_path
    end
  end
end
