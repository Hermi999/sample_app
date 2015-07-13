class UsersController < ApplicationController
  # Before filters:
  # Before editing or updating action is executed, the logged_in_user method
  # has to return true (user is looged in)
  before_action :logged_in_user, only: [:edit, :update]

  # Action for showing the the user profile. params[:id] is extracted from
  # the URL:  '.../users/:id'
  def show
    @user = User.find(params[:id])
  end

  # Action for showing the 'new' view with the signup form. User fills out the
  # form which then will be submitted to the create action. The data will be
  # passed via the params hash.
  def new
    @user = User.new
  end

  # Action for creating a new user, based on the data from the signup form in
  # the 'new' view. The user data is retrieved from the params hash. If it's
  # not possible to save the user, because the validation in the user model
  # failed, then re-render the new view. Otherwise jump to the users profile
  # pate & show a flash message.
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Djungle :)!'
      redirect_to @user  # = redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  # Action for showing the edit view. The formular in the view get's
  # automatically filled with data from the @user member-variable, because we
  # are using the form_for Rails method. The user input is submitted per
  # 'PATCH' (in this case POST, because Browsers can't do PATCH) to the
  # update-action.
  def edit
    @user = User.find(params[:id])
  end

  # Action for updating the user model, based on the data submitted from the
  # form in the create view. The data is retrieved from the params hash. If it
  # is not possible to save the changes, because validation in the user model
  # failed, then re-render the 'edit' view. Otherwise ...
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Updated your data successfully!'
      debugger
      redirect_to @user   # = redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  # Private Methods
  private
    # Use strong parameters to prevent mass-assignment vulnerabily:
    # Defination of which hash-keys have to be present in the params hash.
    # The 'required' one have to be present, while only the 'permited' one's
    # are get copied into a new hash, which is returned by the method.
    def user_params
      params.require(:user).permit( :name, :email,
                                    :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = 'Please log in first!'
        redirect_to login_url
      end
    end
end
