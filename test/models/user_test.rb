# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default("f")
#  activation_digest :string
#  activated         :boolean          default("f")
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User',
                     email: 'user@example.com',
                     password: 'test123',
                     password_confirmation: 'test123')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '    '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '    '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com
                         USER@foo.com
                         A_US-ER@foo.bar.orgg
                         first.last@foo.jp
                         alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, '#{valid_address.inspect} should be valid'
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[ user@example,com
                            user_at_foo.org
                            user.name@example.
                            foo@bar_baz.com
                            foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, '#{invalid_address.inspect} should be invalid'
    end
  end

  test 'is email unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated microposts should be destroyed' do
    # save user in db
    @user.save
    # create 2 new micropost and store it also in db
    @user.microposts.create!(content: 'Test-Post')
    @user.microposts.create!(content: 'Hallo Welt')
    # Delete user and see if the absolut number of microposts is decreasing
    # by the with the user associated number of posts (2)
    assert_difference 'Micropost.count', -2 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    hermann = users(:hermann)
    lini = users(:lini)
    assert_not hermann.following?(lini)
    hermann.follow(lini)
    assert hermann.following?(lini)
    assert lini.followers.include?(hermann)
    hermann.unfollow(lini)
    assert_not hermann.following?(lini)
  end

  test 'feed should have the right posts' do
    hermann = users(:hermann)
    lana    = users(:lana)
    user2   = users(:user_2)

    # Posts from followed user
    lana.microposts.each do |post_following|
      assert hermann.feed.include?(post_following)
    end

    # Posts from self
    hermann.microposts.each do |post_self|
      assert hermann.feed.include?(post_self)
    end

    # Posts from unfollowed user
    user2.microposts.each do |post_unfollowed|
      assert_not hermann.feed.include?(post_unfollowed)
    end
  end
end
