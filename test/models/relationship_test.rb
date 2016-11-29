require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:foo).id,
                                     followed_id: users(:bar).id)
  end
  test "should be valid" do
    assert @relationship.valid?
  end
end
