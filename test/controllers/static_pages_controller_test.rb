# run all test with "rake test"

require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  # The setup function is automatically run bevore every test
  def setup
  	@base_title = "Ruby on Rails Tutorial Sample App"
  end


  test "should get home" do
    get :home										# Issue a get request to the 'home' action of the StaticPages Controller
    assert_response :success		# The response should be the HTTP Status Code '200 ok'
    assert_select "title", "Home | #{@base_title}"		# Check for a tag named "title" with assert_select witch contains the string "..."
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
  	get :about
  	assert_response :success
  	assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
  	get :contact
  	assert_response :success
  	assert_select "title", "Contact | #{@base_title}"
  end
end
