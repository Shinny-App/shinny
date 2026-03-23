require "test_helper"

class LeaguesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post session_url, params: { email_address: @user.email_address, password: "password" }
    @league = leagues(:ice_league)
  end

  test "standings renders standings page" do
    get standings_league_url(@league)
    assert_response :success
    assert_match "Standings", response.body
  end

  test "standings shows team names" do
    get standings_league_url(@league)
    assert_response :success
    assert_match teams(:team_a).name, response.body
    assert_match teams(:team_b).name, response.body
  end

  test "standings shows correct columns" do
    get standings_league_url(@league)
    assert_select "th", "GP"
    assert_select "th", "W"
    assert_select "th", "L"
    assert_select "th", "T"
    assert_select "th", "PTS"
  end

  test "standings requires authentication" do
    delete session_url
    get standings_league_url(@league)
    assert_redirected_to new_session_url
  end

  test "standings page has turbo stream subscription" do
    get standings_league_url(@league)
    assert_response :success
    assert_match "league_#{@league.id}_standings", response.body
  end
end
