require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    # Sign in by setting the session cookie
    post session_url, params: { email_address: @user.email_address, password: "password" }
  end

  test "show renders schedule for authenticated user with teams" do
    get dashboard_url
    assert_response :success
    assert_select "h1", "My Schedule"
  end

  test "show displays upcoming games" do
    get dashboard_url
    assert_response :success
    # User one is on team_a, scheduled_game has team_a as home_team
    assert_match games(:scheduled_game).home_team.name, response.body
  end

  test "show displays past games in collapsible section" do
    get dashboard_url
    assert_response :success
    assert_select "details summary", "Previous games"
  end

  test "show requires authentication" do
    delete session_url
    get dashboard_url
    assert_redirected_to new_session_url
  end

  test "root path renders dashboard for authenticated user" do
    get root_url
    assert_response :success
  end
end
