require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    # access fixture 'hermann'
    @user = users(:hermann)
  end


  test 'login with invalid information' do
    # 1. Visit login page
    get login_path
    # 2. Verify that new sessions form renders properly
    assert_template 'sessions/new'
    # 3. Post the sessions path with an invalid params hash
    post login_path, { session: { email: 'a@a.at', password: 'abc' } }
    # 4. Verify that the new sessions form gets rerendered & a flash is shown
    assert_template 'sessions/new'
    assert_not flash.empty?
    # 5. Visit another page
    get root_path
    # 6. Verify that the flash message doesn't appear on the new page
    assert flash.empty?
  end

  test 'login with valid information followed by a logout' do
    get login_path
    post login_path, session: { email: @user.email, password: 'passwort' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with remembering' do
    log_in_as(@user, remember_me: '1')
    # assert_not_nil cookies['remember_token']
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test 'login without remembering' do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
