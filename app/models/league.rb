class League < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :games, dependent: :destroy
  belongs_to :default_location, class_name: "Location", optional: true

  enum :league_type, { ice: 0, street: 1 }

  validates :name, presence: true

  def standings
    teams.map { |team|
      wins = completed_games.count { |g| winner(g) == team }
      losses = completed_games.count { |g| loser(g) == team }
      ties = completed_games.count { |g| g.home_score == g.away_score && (g.home_team == team || g.away_team == team) }
      games_played = wins + losses + ties
      points = (wins * 2) + (ties * 1)
      { team: team, wins: wins, losses: losses, ties: ties, games_played: games_played, points: points }
    }.sort_by { |s| -s[:points] }
  end

  private

  def completed_games
    @completed_games ||= games.completed.includes(:home_team, :away_team)
  end

  def winner(game)
    return nil if game.home_score == game.away_score
    game.home_score > game.away_score ? game.home_team : game.away_team
  end

  def loser(game)
    return nil if game.home_score == game.away_score
    game.home_score < game.away_score ? game.home_team : game.away_team
  end
end
