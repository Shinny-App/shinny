require "test_helper"

class TeamTest < ActiveSupport::TestCase
  test "validates name presence" do
    team = Team.new(league: leagues(:ice_league))
    assert_not team.valid?
    assert_includes team.errors[:name], "can't be blank"
  end

  test "belongs_to league" do
    team = teams(:team_a)
    assert_equal leagues(:ice_league), team.league
  end

  test "has_many memberships" do
    team = teams(:team_a)
    assert_includes team.memberships, memberships(:captain_one_team_a)
  end

  test "has_many users through memberships" do
    team = teams(:team_a)
    assert_includes team.users, users(:one)
  end
end
