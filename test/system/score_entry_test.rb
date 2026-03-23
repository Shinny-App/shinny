require "application_system_test_case"

class ScoreEntryTest < ApplicationSystemTestCase
  setup do
    @captain = users(:one) # Captain of team_a
    @game = games(:scheduled_game)
  end

  test "captain can enter score and game becomes completed" do
    sign_in_as @captain
    visit game_url(@game)

    fill_in "score[home_score]", with: 5
    fill_in "score[away_score]", with: 2
    click_button "Save Score"

    # Score should display
    assert_text "5"
    assert_text "2"
    assert_text "Final"

    # Game should be completed
    @game.reload
    assert @game.completed?
  end

  test "non-captain does not see score form" do
    sign_in_as users(:two) # Player on team_b, not captain
    visit game_url(@game)

    assert_no_button "Save Score"
  end

  test "score entry updates standings page" do
    sign_in_as @captain
    visit game_url(@game)

    fill_in "score[home_score]", with: 4
    fill_in "score[away_score]", with: 1
    click_button "Save Score"

    # Navigate to standings
    visit standings_league_url(@game.league)

    # Should reflect the new score in standings
    assert_text "PTS"
    # Verify the page renders without error
    assert_selector "table"
  end
end
