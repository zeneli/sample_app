require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:foo).id,
                                     followed_id: users(:bar).id)
  end
  test "should be valid" do
    assert @relationship.valid?
  end
  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end
  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test "should follow and unfollow a user" do
    foo = users(:foo)
    archer = users(:archer)
    assert_not foo.following?(archer)
    foo.follow(archer)
    assert foo.following?(archer)
    foo.unfollow(archer)
    assert_not foo.following?(archer)
  end
end
