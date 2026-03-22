require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "validates name presence" do
    location = Location.new(league: leagues(:ice_league))
    assert_not location.valid?
    assert_includes location.errors[:name], "can't be blank"
  end

  test "belongs_to league" do
    location = locations(:main_rink)
    assert_equal leagues(:ice_league), location.league
  end

  test "address is optional" do
    location = Location.new(name: "Test Rink", league: leagues(:ice_league))
    assert location.valid?
  end
end
