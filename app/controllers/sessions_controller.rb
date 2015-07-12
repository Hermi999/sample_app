class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user in
      log_in user

      # Does the user want's to be remembered?
      # Yes:  Helper: create permanent session tokens (Cookies)
      # No:   Delete the permanent cookies and field in database. Now he won't
      # be remembered in any browser he used this feature
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      # create an error message and show login page (session new) again
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
