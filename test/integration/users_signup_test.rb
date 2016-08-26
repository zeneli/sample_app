require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  test "invalid signup information (verbose)" do
    get signup_path
    before_count = User.count
    post signup_path, params: { user: { name: "",
                                       email: "user@invalid",
                                       password:              "foo",
                                       password_confirmation: "bar" } }
    after_count = User.count
    assert_equal before_count, after_count
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert-success'#, " Welcome to the Sample App! "
  end
        
  test "valid signup information (verbose) " do
    get signup_path
    assert_select 'form[action="/signup"]'
    before_count = User.count
    post signup_path, params: { user: { name: "Valid User",
                                       email: "user@example.com",
                                       password:              "foobar",
                                       password_confirmation: "foobar" } }
    after_count = User.count
    assert_equal before_count + 1, after_count
    follow_redirect!
    assert_template 'users/show'
  end
end
