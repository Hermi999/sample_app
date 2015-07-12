require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'a user with invalid signup info does not get saved' do
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


  test ' a user with valid signup info gets saved in database' do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user:  {
                                name:                 'Hermann',
                                email:                'a@a.at',
                                password:             'dasisteintest',
                                password_confirmation:'dasisteintest'
                              }
    end
    assert_template 'users/show'
    assert is_logged_in?
  end
end
