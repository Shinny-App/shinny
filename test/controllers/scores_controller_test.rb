require "test_helper"

class ScoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    # User one is captain of team_a
    @captain = users(:one)
    post session_url, params: { email_address: @captain.email_address, password: "password" }
  end

  test "captain can enter score" do
    game = games(:scheduled_game)
    patch game_score_url(game), params: { score: { home_score: 4, away_score: 2 } }
    game.reload
    assert_equal 4, game.home_score
    assert_equal 2, game.away_score
    assert game.completed?
  end

  test "captain can correct score on completed game" do
    game = games(:completed_game)
    patch game_score_url(game), params: { score: { home_score: 5, away_score: 3 } }
    game.reload
    assert_equal 5, game.home_score
    assert_equal 3, game.away_score
  end

  test "non-captain cannot enter score" do
    # Sign in as user two (player on team_b, not captain)
    delete session_url
    post session_url, params: { email_address: users(:two).email_address, password: "password" }
    game = games(:scheduled_game)
    patch game_score_url(game), params: { score: { home_score: 1, away_score: 0 } }
    assert_redirected_to game_url(game)
    game.reload
    assert_nil game.home_score
  end

  test "score entry rejected for cancelled game" do
    game = games(:cancelled_game)
    patch game_score_url(game), params: { score: { home_score: 2, away_score: 1 } }
    assert_redirected_to game_url(game)
    game.reload
    assert_nil game.home_score
  end

  test "score entry returns turbo stream" do
    game = games(:scheduled_game)
    patch game_score_url(game),
      params: { score: { home_score: 3, away_score: 1 } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "turbo-stream", response.body
  end
end
