module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Return the current logged-in user (if any). 
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Return ture if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?  # method call, returns if object is nil (negated)
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirect to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
  
end
