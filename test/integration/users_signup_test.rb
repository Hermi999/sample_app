require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    # Reset amount of send email deliveries
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {
                              name:                   '',
                              email:                  'user@invalid',
                              password:               'foo',
                              password_confirmation:  'bar'
                             }
    end
    assert_template 'users/new'   # does fail leed to new-page again?
  end


  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user:  { name:                 'Hermann',
                                email:                'a@a.at',
                                password:             'dasisteintest',
                                password_confirmation:'dasisteintest'
                              }
    end
    # There should be one new email
    assert_equal 1, ActionMailer::Base.deliveries.size

    # assigns let us access the instance variable @user in this action
    # @user was filled with data with the previous post request
    user = assigns(:user)

    # User should not yet be activated
    assert_not user.activated?

    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?

    # Invalid activation token
    get edit_account_activation_path('invalid token')
    assert_not is_logged_in?

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?

    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
