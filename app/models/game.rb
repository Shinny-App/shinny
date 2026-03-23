class Game < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  belongs_to :location, optional: true
  has_many :rsvps, dependent: :destroy

  enum :status, { scheduled: 0, completed: 1, cancelled: 2 }

  validates :scheduled_at, presence: true
  validates :home_score, presence: true, if: :completed?
  validates :away_score, presence: true, if: :completed?
  validate :teams_belong_to_same_league
  validate :teams_are_different
  validate :scheduled_at_in_future, on: :create

  after_update_commit :broadcast_score_update, if: -> { saved_change_to_home_score? || saved_change_to_away_score? }

  scope :upcoming, -> { where(status: :scheduled).where("scheduled_at > ?", Time.current).order(scheduled_at: :asc) }
  scope :past, -> { where("scheduled_at <= ? OR status IN (?)", Time.current, [ statuses[:completed], statuses[:cancelled] ]).order(scheduled_at: :desc) }
  scope :for_teams, ->(team_ids) { where(home_team_id: team_ids).or(where(away_team_id: team_ids)) }

  def resolved_location
    location || league.default_location
  end

  def rsvp_counts_for_team(team)
    team_user_ids = team.users.pluck(:id)
    team_rsvps = rsvps.where(user_id: team_user_ids)
    {
      yes: team_rsvps.yes.count,
      no: team_rsvps.no.count,
      maybe: team_rsvps.maybe.count,
      no_response: team_user_ids.size - team_rsvps.count
    }
  end

  def rsvp_deadline_passed?
    rsvp_deadline.present? && Time.current > rsvp_deadline
  end

  def user_team(user)
    team_ids = user.teams.pluck(:id)
    if team_ids.include?(home_team_id)
      home_team
    elsif team_ids.include?(away_team_id)
      away_team
    end
  end

  def roster_for_team(team)
    team_user_ids = team.users.pluck(:id)
    game_rsvps = rsvps.includes(:user).where(user_id: team_user_ids)
    non_responders = team.users.where.not(id: game_rsvps.select(:user_id))
    {
      yes: game_rsvps.select(&:yes?),
      no: game_rsvps.select(&:no?),
      maybe: game_rsvps.select(&:maybe?),
      no_response: non_responders
    }
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

  def broadcast_score_update
    broadcast_replace_to "league_#{league_id}_standings",
      target: "league_#{league_id}_standings_table",
      partial: "leagues/standings_table",
      locals: { league: league }

    broadcast_replace_to self,
      target: "game_#{id}_score",
      partial: "games/score_display",
      locals: { game: self }
  end
end
