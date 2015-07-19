class UsersController < ApplicationController
  # Before filters:
  # Restrict actions which are only for a logged in user
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]

  # Restrict action which are only for the correct user and not for other users
  before_action :correct_user, only: [:edit, :update]

  # Restrict actions which are only for admins
  before_action :admin_user, only: :destroy

  # Action for showing all the registered users on one page (with pagination)
  def index
    # params[:page] ... is generated automatically by will_paginate
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # Remove user from database - only for admins!
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  # Action for showing the the user profile. params[:id] is extracted from
  # the URL:  '.../users/:id'
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
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
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account!'
      redirect_to root_url
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
      redirect_to @user   # = redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  # Action for displaying all other users which are followed by a logged in
  # user.
  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  # Action for displaying all other users which are following a logged in user
  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
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

    # Verify if user who want's to access the page, is the logged-in user
    # Otherwise redirect.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Verify if the user is an admin
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
