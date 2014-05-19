class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def is_user?
  	return !session[:user_id].nil?
  end

  def is_admin?
  	return !session[:admin_id].nil?
  end

end
