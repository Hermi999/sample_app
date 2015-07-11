require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'a user with invalid signup information does not get saved' do
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
end
