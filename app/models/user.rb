class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :rsvps, dependent: :destroy

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :display_name, presence: true

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt.last(10)
  end

  def upcoming_games
    Game.upcoming.for_teams(teams.pluck(:id))
  end

  def past_games
    Game.past.for_teams(teams.pluck(:id))
  end

  def captain_of?(team)
    memberships.exists?(team: team, role: :captain)
  end

  def captain_in_game?(game)
    captain_of?(game.home_team) || captain_of?(game.away_team)
  end
end
