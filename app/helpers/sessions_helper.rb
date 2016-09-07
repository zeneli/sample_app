module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Return the current logged-in user (if any). 
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Return ture if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?  # method call, returns if object is nil (negated)
  end
end
