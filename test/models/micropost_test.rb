require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:foo)
    # This code is not idiomatically correct.
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
  end
  test "should be valid" do
    assert @micropost.valid?
  end
  test "usser id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
end