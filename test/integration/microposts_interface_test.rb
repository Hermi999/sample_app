require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:hermann)
  end

  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: '' }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    content = 'This is a valid micropost'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count' do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # Delete a post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit a dirfferent user - there shouldn't be a delete link
    get user_path(users(:lini))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    delete logout_path
    follow_redirect!
    assert_match 'Welcome to the Sample App', response.body

    # User with 0 microposts
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match '0 microposts', response.body

    # Create a micropost & check for right singularization
    other_user.microposts.create!(content: 'Test micropost')
    get root_path
    assert_match '1 micropost', response.body
  end
end
