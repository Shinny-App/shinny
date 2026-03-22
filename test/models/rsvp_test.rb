require "test_helper"

class RsvpTest < ActiveSupport::TestCase
  test "belongs_to user" do
    rsvp = rsvps(:rsvp_one)
    assert_equal users(:one), rsvp.user
  end

  test "belongs_to game" do
    rsvp = rsvps(:rsvp_one)
    assert_equal games(:scheduled_game), rsvp.game
  end

  test "response enum works" do
    assert_equal 0, Rsvp.responses[:yes]
    assert_equal 1, Rsvp.responses[:no]
    assert_equal 2, Rsvp.responses[:maybe]
    assert rsvps(:rsvp_one).yes?
  end

  test "validates responded_at presence" do
    rsvp = Rsvp.new(user: users(:two), game: games(:scheduled_game), response: :yes)
    assert_not rsvp.valid?
    assert_includes rsvp.errors[:responded_at], "can't be blank"
  end

  test "duplicate user and game raises validation error" do
    duplicate = Rsvp.new(
      user: users(:one),
      game: games(:scheduled_game),
      response: :no,
      responded_at: Time.current
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end
end
