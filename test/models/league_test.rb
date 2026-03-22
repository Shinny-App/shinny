require "test_helper"

class LeagueTest < ActiveSupport::TestCase
  test "validates name presence" do
    league = League.new(league_type: :ice)
    assert_not league.valid?
    assert_includes league.errors[:name], "can't be blank"
  end

  test "league_type enum works" do
    assert_equal 0, League.league_types[:ice]
    assert_equal 1, League.league_types[:street]
    assert leagues(:ice_league).ice?
    assert leagues(:street_league).street?
  end

  test "active defaults to true" do
    league = League.new(name: "Test League", league_type: :ice)
    assert league.active
  end

  test "has_many locations" do
    league = leagues(:ice_league)
    assert_includes league.locations, locations(:main_rink)
  end

  test "has_many teams" do
    league = leagues(:ice_league)
    assert_includes league.teams, teams(:team_a)
    assert_includes league.teams, teams(:team_b)
  end

  test "has_many games" do
    league = leagues(:ice_league)
    assert_includes league.games, games(:scheduled_game)
  end

  test "belongs_to default_location is optional" do
    league = League.new(name: "Test", league_type: :ice)
    assert league.valid?
  end

  test "standings returns correct points: win=2, tie=1, loss=0" do
    league = leagues(:ice_league)
    standings = league.standings

    team_a_entry = standings.find { |s| s[:team] == teams(:team_a) }
    team_b_entry = standings.find { |s| s[:team] == teams(:team_b) }

    # team_a: 1 win (completed_game 3-1), 1 tie (tied_game 2-2) => 3 points
    assert_equal 1, team_a_entry[:wins]
    assert_equal 0, team_a_entry[:losses]
    assert_equal 1, team_a_entry[:ties]
    assert_equal 3, team_a_entry[:points]

    # team_b: 0 wins, 1 loss, 1 tie => 1 point
    assert_equal 0, team_b_entry[:wins]
    assert_equal 1, team_b_entry[:losses]
    assert_equal 1, team_b_entry[:ties]
    assert_equal 1, team_b_entry[:points]
  end

  test "standings sorts by points descending" do
    league = leagues(:ice_league)
    standings = league.standings
    points = standings.map { |s| s[:points] }
    assert_equal points.sort.reverse, points
  end

  test "standings excludes cancelled games" do
    league = leagues(:ice_league)
    standings = league.standings
    total_games = standings.sum { |s| s[:games_played] }
    # cancelled_game should not be counted, only completed_game and tied_game
    # each game counts for 2 teams, so 2 completed games * 2 = 4 total team appearances
    assert_equal 4, total_games
  end

  test "standings handles teams with no completed games" do
    league = leagues(:street_league)
    standings = league.standings
    street_team_entry = standings.find { |s| s[:team] == teams(:street_team) }
    assert_equal 0, street_team_entry[:points]
    assert_equal 0, street_team_entry[:games_played]
  end

  test "standings does not count completed games with nil scores as ties" do
    league = leagues(:ice_league)
    standings = league.standings

    # null_score_game is completed but has no scores; must not inflate ties or games_played
    team_a_entry = standings.find { |s| s[:team] == teams(:team_a) }
    team_b_entry = standings.find { |s| s[:team] == teams(:team_b) }

    assert_equal 1, team_a_entry[:ties]
    assert_equal 2, team_a_entry[:games_played]
    assert_equal 1, team_b_entry[:ties]
    assert_equal 2, team_b_entry[:games_played]
  end

  test "destroying a league with a default_location does not raise a foreign key error" do
    league = leagues(:ice_league)
    location = locations(:main_rink)
    league.update!(default_location: location)

    assert_nothing_raised { league.destroy! }
  end
end
