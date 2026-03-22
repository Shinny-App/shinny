class Game < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  belongs_to :location, optional: true
  has_many :rsvps, dependent: :destroy

  enum :status, { scheduled: 0, completed: 1, cancelled: 2 }

  validates :scheduled_at, presence: true
  validate :teams_belong_to_same_league
  validate :teams_are_different
  validate :scheduled_at_in_future, on: :create

  def resolved_location
    location || league.default_location
  end

  private

  def teams_belong_to_same_league
    return unless home_team && away_team && league
    unless home_team.league_id == league_id && away_team.league_id == league_id
      errors.add(:base, "both teams must belong to the same league as the game")
    end
  end

  def teams_are_different
    return unless home_team_id && away_team_id
    if home_team_id == away_team_id
      errors.add(:base, "home team and away team must be different")
    end
  end

  def scheduled_at_in_future
    return unless scheduled_at
    if scheduled_at <= Time.current
      errors.add(:scheduled_at, "must be in the future")
    end
  end
end
