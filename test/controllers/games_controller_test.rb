require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post session_url, params: { email_address: @user.email_address, password: "password" }
    @game = games(:scheduled_game)
  end

  test "show renders game detail" do
    get game_url(@game)
    assert_response :success
    assert_match @game.home_team.name, response.body
    assert_match @game.away_team.name, response.body
  end

  test "show requires authentication" do
    delete session_url
    get game_url(@game)
    assert_redirected_to new_session_url
  end

  test "show displays RSVP buttons for team member" do
    get game_url(@game)
    assert_response :success
    assert_match "rsvp_buttons", response.body
    assert_match "I&#39;m in", response.body
  end

  test "show displays score for completed game" do
    get game_url(games(:completed_game))
    assert_response :success
    assert_match "3", response.body
    assert_match "1", response.body
  end
end
