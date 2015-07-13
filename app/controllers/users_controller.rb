class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Djungle :)!'
      redirect_to @user  # = redirect_to user_url_(@user)
    else
      render 'new'
    end
  end

  def edit
    # Action for editing the user. The formular in the view get's automatically
    # filled with data from the @user membarvariable, because we are using
    # the form_for Rails method.
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit( :name, :email,
                                    :password, :password_confirmation)
    end
end
