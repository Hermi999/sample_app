class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user in
    else
      # create an error message and show login page (session new) again
      render 'new'
    end
  end

  def destroy

  end
end
