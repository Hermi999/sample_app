class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])

      if @user.activated?
        log_in @user
        # Does the user want's to be remembered?
        # Yes:  Helper: create permanent session tokens (Cookies)
        # No:   Delete the permanent cookies and field in database. Now he won't
        # be remembered in any browser he used this feature
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message =  t(:account_not_activated_1)
        message += t(:account_not_activated_2)
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # create an error message and show login page (session new) again
      flash.now[:danger] = t(:invalid_email_password)
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
