class ApplicationController < ActionController::Base
  
  helper_method :current_user, :require_login
  
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def require_login
    redirect_to new_session_url unless current_user
  end
  
end
