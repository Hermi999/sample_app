require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:hermann)
    @non_admin = users(:lini)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'

    i = 1
    unact = 0
    until (page_of_users = User.paginate(page: i)).empty?
      # Go to next page
      get users_path, page: i

      # Go through each user on this page
      x = 0
      page_of_users.each do |user|
        # Skip the first few entries on pages 2, 3, ..., because on the page
        # the not activated users are not shown, while in page_of_users all
        # the users are stored
        if (x <= unact)
          x += 1
        else
          if !user.activated?
            unact += 1
            assert_select 'a[href=?]', user_path(user), text: user.name, count: 0
          else
            assert_select 'a[href=?]', user_path(user), text: user.name
            unless user == @admin
              assert_select 'a[href=?]', user_path(user), text: 'delete'
            end
          end
        end
      end
      i += 1
    end

    assert_difference 'User.count', -1 do
      delete user_path @non_admin
    end
  end

  test 'index as non-admin' do
    log_in_as @non_admin
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
