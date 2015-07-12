module SessionsHelper
  # Logs in the given user by creating a temporary session cookie
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any), by checking if the encrypted
  # session id corresponds to a user id
  def current_user
    current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
