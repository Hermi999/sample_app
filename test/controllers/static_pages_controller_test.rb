# run all test with 'rake test'

require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test 'should get home' do
    # Issue a get request to the 'home' action of the StaticPages Controller
    get :home
    # The response should be the HTTP Status Code '200 ok'
    assert_response :success
    # Check for a tag named 'title' with witch contains the string '...'
    assert_select 'title', 'Ruby on Rails Tutorial Sample App'
  end

  test 'should get help' do
    get :help
    assert_response :success
    assert_select 'title', 'Help | Ruby on Rails Tutorial Sample App'
  end

  test 'should get about' do
    get :about
    assert_response :success
    assert_select 'title', 'About | Ruby on Rails Tutorial Sample App'
  end
end
