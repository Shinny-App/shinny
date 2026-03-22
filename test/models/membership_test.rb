require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  test "belongs_to user" do
    membership = memberships(:player_one_team_a)
    assert_equal users(:one), membership.user
  end

  test "belongs_to team" do
    membership = memberships(:player_one_team_a)
    assert_equal teams(:team_a), membership.team
  end

  test "role enum works" do
    assert_equal 0, Membership.roles[:player]
    assert_equal 1, Membership.roles[:captain]
    assert_equal 2, Membership.roles[:admin]
    assert memberships(:player_one_team_a).player?
  end

  test "duplicate user and team raises validation error" do
    duplicate = Membership.new(
      user: users(:one),
      team: teams(:team_a),
      role: :player
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end
end
