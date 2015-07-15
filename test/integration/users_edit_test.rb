require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # Get user 'hermann' from fixtures
  def setup
    @user = users(:hermann)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:  '',
                                    email: 'foo@bar',
                                    password: 'foo',
                                    password_confirmation: 'bar1' }
    assert_template 'users/edit'
  end

  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Test Name'
    email = 'test@email.at'
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: '',
                                    password_confirmation: ''
                                  }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload                      # reload user values from db
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)

    # Check if we get redirected
    assert_not_nil session[:forwarding_url]     # there should be a url
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)  # after login -> redirect

    # Check if we do not get redirected again
    assert_nil session[:forwarding_url]         # after login -> no redirect
    get user_path @user
    assert_template 'users/show'
    get edit_user_path @user
    assert_template 'users/edit'

    # Check if changes are possible & user gets updated in database
    name = 'Test Name'
    email = 'test@email.at'
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: '',
                                    password_confirmation: ''
                                  }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload                      # reload user values from db
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
