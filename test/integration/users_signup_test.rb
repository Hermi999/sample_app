require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'a user with invalid signup info does not get saved & shows errors' do
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
    # errors?
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end



  test 'invalid signup infos leed to error messages' do
    get signup_path

    # create different invalid users
    empty_user =
                { user:
                  { name: '',
                    email: '',
                    password: '',
                    password_confirmation: ''
                  }
                }
    empty_email_user =
                { user:
                   { name:                   'hermann',
                     email:                  'abc',
                     password:               'dasisteinpassword',
                     password_confirmation:  'dasisteinpassword'
                   }
                }
    short_password_user =
                { user:
                   { name:                   'hermann',
                     email:                  'hermann.wagner01@gmx.at',
                     password:               'abc',
                     password_confirmation:  'abc'
                   }
                }
    password_conf_user =
                { user:
                   { name:                   'hermann',
                     email:                  'hermann.wagner01@gmx.at',
                     password:               'dasisteinpassword',
                     password_confirmation:  'dasisteinpassworD'
                   }
                }
    valid_user =
                { user:
                   { name:                   'hermann',
                     email:                  'hermann.wagner01@gmx.at',
                     password:               'dasisteinpassword',
                     password_confirmation:  'dasisteinpassword'
                   }
                }

    # test all empty messages
    post users_path, empty_user
    assert_select 'li', "Name can't be blank"
    assert_select 'li', "Email can't be blank"
    assert_select 'li', "Password can't be blank"

    # test invalid email message
    post users_path, empty_email_user
    assert_select 'li', 'Email is invalid'
    assert_select 'div', 'The form contains 1 error.'

    # test user password length message
    post users_path, short_password_user
    assert_select 'li', 'Password is too short (minimum is 6 characters)'
    assert_select 'div.alert-danger', 'The form contains 1 error.'

    # test password confirmation
    post users_path, password_conf_user
    assert_select 'li', "Password confirmation doesn't match Password"
    assert_select 'div.alert-danger', 'The form contains 1 error.'

    # test if email has already been taken message is visible
    post users_path, valid_user
    post users_path, valid_user
    assert_select 'li', 'Email has already been taken'
    assert_select 'div.alert-danger', 'The form contains 1 error.'
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

    # check if flash message is displayed
    assert_not_nil flash

    # check if flash shows success message (maybe already too much)
    assert flash[:success]
  end
end
