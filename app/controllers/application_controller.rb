class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
      #if there is a user_id in our session hash provided by the browswer, then find the database for that user with the user_id
  end

  def logged_in?
    !!current_user
    #!! converts anything into a boolean value. Checks if there is a current user or not
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end

end
