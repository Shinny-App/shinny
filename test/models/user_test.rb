require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user saves successfully" do
    user = User.new(
      email_address: "newuser@example.com",
      password: "secret123",
      password_confirmation: "secret123",
      display_name: "New User"
    )
    assert user.valid?
    assert user.save
  end

  test "email_address is required" do
    user = User.new(password: "secret123", display_name: "Test")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "email_address must be unique" do
    existing = users(:one)
    user = User.new(
      email_address: existing.email_address,
      password: "secret123",
      display_name: "Duplicate"
    )
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "email_address uniqueness is case-insensitive due to normalization" do
    existing = users(:one)
    user = User.new(
      email_address: existing.email_address.upcase,
      password: "secret123",
      display_name: "Duplicate"
    )
    assert_not user.valid?
  end

  test "display_name is required" do
    user = User.new(email_address: "test@example.com", password: "secret123")
    assert_not user.valid?
    assert_includes user.errors[:display_name], "can't be blank"
  end

  test "password is required on create" do
    user = User.new(email_address: "test@example.com", display_name: "Test")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "has_many sessions association" do
    user = users(:one)
    assert_respond_to user, :sessions
    assert_includes user.sessions, sessions(:one)
  end

  test "has_many memberships" do
    user = users(:one)
    assert_respond_to user, :memberships
    assert_includes user.memberships, memberships(:captain_one_team_a)
  end

  test "has_many teams through memberships" do
    user = users(:one)
    assert_respond_to user, :teams
    assert_includes user.teams, teams(:team_a)
  end

  test "has_many rsvps" do
    user = users(:one)
    assert_respond_to user, :rsvps
    assert_includes user.rsvps, rsvps(:rsvp_one)
  end
end
