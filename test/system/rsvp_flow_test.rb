require "application_system_test_case"

class RsvpFlowTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @game = games(:scheduled_game)
  end

  test "user can RSVP yes to a game" do
    # Delete existing RSVP so we test create flow
    Rsvp.where(user: @user, game: @game).delete_all

    sign_in_as @user
    find("#game_#{@game.id}_card").click

    # Click "I'm in" button
    click_button "I'm in"

    # Button should now show as selected (green background)
    assert_selector "button", text: "I'm in"
    # RSVP should be saved
    assert Rsvp.exists?(user: @user, game: @game, response: :yes)
  end

  test "user can change RSVP response" do
    sign_in_as @user
    find("#game_#{@game.id}_card").click

    # User one already has RSVP 'yes' for scheduled_game
    # Change to 'no'
    click_button "Can't make it"

    # Verify the response changed without page reload
    rsvp = Rsvp.find_by(user: @user, game: @game)
    assert_equal "no", rsvp.response
  end

  test "deadline passed shows read-only RSVP status" do
    sign_in_as @user
    visit game_url(games(:deadline_passed_game))

    # Should see read-only status, not buttons
    assert_text "deadline has passed"
    assert_no_button "I'm in"
  end

  test "RSVP updates counts without page reload" do
    Rsvp.where(user: @user, game: @game).delete_all

    sign_in_as @user
    find("#game_#{@game.id}_card").click

    click_button "I'm in"

    # The roster section should update to show the user
    within "#game_#{@game.id}_team_#{teams(:team_a).id}_roster" do
      assert_text @user.display_name
    end
  end
end
