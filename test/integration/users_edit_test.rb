require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # Get user 'hermann' from fixtures
  def setup
    @user = users(:hermann)
  end

  test 'unsuccessful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:  '',
                                    email: 'foo@bar',
                                    password: 'foo',
                                    password_confirmation: 'bar1' }
    assert_template 'users/edit'
  end

  test 'successful edit' do
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
end
