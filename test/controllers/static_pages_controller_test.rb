# run all test with "rake test"

require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home										# Issue a get request to the 'home' action of the StaticPages Controller
    assert_response :success		# The response should be the HTTP Status Code '200 ok'
    assert_select "title", "Home | Ruby on Rails Tutorial Sample App"		# Check for a tag named "title" with assert_select witch contains the string "..."
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end

  test "should get about" do
  	get :about
  	assert_response :success
  	assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end
end