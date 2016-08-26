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
  test "invalid signup information (longer)" do
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
end
