require "application_system_test_case"

class TurboStreamTest < ApplicationSystemTestCase
  test "RSVP submission returns turbo stream and updates DOM" do
    user = users(:one)
    game = games(:deadline_future_game)
    Rsvp.where(user: user, game: game).delete_all

    sign_in_as user
    visit game_url(game)

    # The RSVP buttons should be present
    assert_selector "#game_#{game.id}_rsvp_buttons"

    click_button "I'm in"

    # After Turbo Stream response, the buttons area should still be present (replaced, not removed)
    assert_selector "#game_#{game.id}_rsvp_buttons"

    # The roster should be updated
    assert_selector "#game_#{game.id}_team_#{teams(:team_a).id}_roster"
  end

  test "score entry turbo stream updates score display" do
    captain = users(:one)
    game = games(:scheduled_game)

    sign_in_as captain
    visit game_url(game)

    fill_in "score[home_score]", with: 3
    fill_in "score[away_score]", with: 0
    click_button "Save Score"

    # Score display should be updated via Turbo Stream
    within "#game_#{game.id}_score" do
      assert_text "3"
      assert_text "0"
      assert_text "Final"
    end
  end
end
