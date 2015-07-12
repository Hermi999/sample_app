module SessionsHelper
  # Logs in the given user by creating a temporary session cookie
  def log_in(user)
    session[:user_id] = user.id
  end

  # Creates a random token and stores it in the database
  # Creates two permanent (20 years) cookies for storage in the users browser
  # The user_id cookie is always the same for the user and gets encrypted, so
  # that the actual user.id is never exposed
  # The remember_token is a random base64 string and will be changed if the
  # user logs out and in again. In this way an attacker who can extract the
  # cookies somehow, can take over the account maximal until the user logs out
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns a logged-in user based on the browser cookies.
  # This is either done by checking if the encrypted temporary session id
  # corresponds to a user id or it's done with the permanent remember tokens
  # (also cookies)
  def current_user
    # if temporary session exists
    if (user_id = session[:user_id])
      # search for (temporary) user-id in database (only the first time)
      @current_user ||= User.find_by(id: user_id)

    # if permanent sessions token exists
    elsif (user_id = cookies.signed[:user_id])
      # search for (permanent) user-id in database
      user = User.find_by(id: user_id)
      # if there exists a user with this id, then check if remember_token
      # matches the hashed one in the databse. If yes, then log the user in.
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise
  # This method instantiates the whole temporary and permanent "remember me"
  # authentification process & is called in the _header,html.erb partial
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent user session
  def forget(user)
    user.forget                     # set database field to nil
    cookies.delete :user_id         # delete permanent cookies
    cookies.delete :remember_token
  end

  # Logs out the current user
  def log_out
    forget(current_user)      # retrieve current user and then forget him
    session.delete(:user_id)  # delete temporary session cookie
    @current_user = nil       # set current user to nil
  end
end
