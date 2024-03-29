require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup		# create a valid user
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  # test our setup @user is valid
  test "should be valid" do
    assert @user.valid?
  end

  # test presence of @user.name and @user.email
  test "name should be present" do
    @user.name = "			"
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email = "			"
    assert_not @user.valid?
  end

  # test length of @user.name and @user.email
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # test format of @user.email
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM 
        A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org 
        user.name@example. foo@bar_baz.com foo@bar+baz.com
        foo@bar..com ]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should not be valid"
    end
  end

  # test uniqueness of @user.email
  test "email addresses should be unique up to case sensitivity" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # test email downcasing
  test "email addresses should be lower case after saving" do
    mixed_case_email = "Foo@ExAMPle.Com"
    @user.email = mixed_case_email
    @user.save	
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # test password validations
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    foo = users(:foo)
    archer = users(:archer)
    assert_not foo.following?(archer)
    foo.follow(archer)
    assert foo.following?(archer)
    assert archer.followers.include?(foo)
    foo.unfollow(archer)
    assert_not foo.following?(archer)
  end

  test "feed should have the right posts" do
    foo = users(:foo)
    archer = users(:archer)
    lana = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert foo.feed.include?(post_following)
    end
    # Posts from self
    foo.microposts.each do |post_self|
      assert foo.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not foo.feed.include?(post_unfollowed)
    end
  end
end
