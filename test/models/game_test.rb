require "test_helper"

class GameTest < ActiveSupport::TestCase
  def valid_game_attrs
    {
      league: leagues(:ice_league),
      home_team: teams(:team_a),
      away_team: teams(:team_b),
      scheduled_at: 1.week.from_now
    }
  end

  test "belongs_to league" do
    game = games(:scheduled_game)
    assert_equal leagues(:ice_league), game.league
  end

  test "belongs_to home_team" do
    game = games(:scheduled_game)
    assert_equal teams(:team_a), game.home_team
  end

  test "belongs_to away_team" do
    game = games(:scheduled_game)
    assert_equal teams(:team_b), game.away_team
  end

  test "location is optional" do
    game = Game.new(valid_game_attrs)
    assert game.valid?
  end

  test "has_many rsvps" do
    game = games(:scheduled_game)
    assert_includes game.rsvps, rsvps(:rsvp_one)
  end

  test "status enum works" do
    assert_equal 0, Game.statuses[:scheduled]
    assert_equal 1, Game.statuses[:completed]
    assert_equal 2, Game.statuses[:cancelled]
    assert games(:scheduled_game).scheduled?
    assert games(:completed_game).completed?
    assert games(:cancelled_game).cancelled?
  end

  test "status defaults to scheduled" do
    game = Game.new(valid_game_attrs)
    assert game.scheduled?
  end

  test "validates scheduled_at presence" do
    game = Game.new(valid_game_attrs.except(:scheduled_at))
    assert_not game.valid?
    assert_includes game.errors[:scheduled_at], "can't be blank"
  end

  test "validates scheduled_at in future on create" do
    game = Game.new(valid_game_attrs.merge(scheduled_at: 1.day.ago))
    assert_not game.valid?
    assert_includes game.errors[:scheduled_at], "must be in the future"
  end

  test "allows past scheduled_at on update" do
    game = games(:completed_game)
    game.home_score = 4
    assert game.valid?
  end

  test "validates home_team and away_team belong to same league" do
    game = Game.new(valid_game_attrs.merge(away_team: teams(:street_team)))
    assert_not game.valid?
    assert_includes game.errors[:base], "both teams must belong to the same league as the game"
  end

  test "validates home_team is different from away_team" do
    game = Game.new(valid_game_attrs.merge(away_team: teams(:team_a)))
    assert_not game.valid?
    assert_includes game.errors[:base], "home team and away team must be different"
  end

  test "resolved_location returns game location when set" do
    game = games(:scheduled_game)
    assert_equal locations(:main_rink), game.resolved_location
  end

  test "resolved_location returns league default_location when game location is nil" do
    leagues(:ice_league).update!(default_location: locations(:backup_rink))
    game = games(:null_score_game)
    assert_nil game.location
    assert_equal locations(:backup_rink), game.resolved_location
  end

  test "resolved_location returns nil when both are nil" do
    game = games(:null_score_game)
    leagues(:ice_league).update!(default_location: nil)
    assert_nil game.resolved_location
  end

  test "requires home_score and away_score when completed" do
    game = games(:scheduled_game)
    game.status = :completed
    assert_not game.valid?
    assert_includes game.errors[:home_score], "can't be blank"
    assert_includes game.errors[:away_score], "can't be blank"
  end

  test "completed game with both scores present is valid" do
    game = games(:scheduled_game)
    game.status = :completed
    game.home_score = 3
    game.away_score = 1
    assert game.valid?
  end

  test "scheduled game without scores is valid" do
    game = Game.new(valid_game_attrs)
    assert game.valid?
  end
end
