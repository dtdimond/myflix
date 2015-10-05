class ApplicationController < ActionController::Base
  protect_from_forgery

  #Methods available everywhere
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  #Methods only available in controllers
  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to do that."
      redirect_to root_path
    end
  end
end
