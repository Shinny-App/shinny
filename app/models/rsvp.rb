class Rsvp < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum :response, { yes: 0, no: 1, maybe: 2 }

  validates :user_id, uniqueness: { scope: :game_id }
  validates :responded_at, presence: true

  after_save_commit :broadcast_rsvp_update

  private

  def broadcast_rsvp_update
    team = game.user_team(user)
    return unless team

    broadcast_replace_to game,
      target: "game_#{game_id}_team_#{team.id}_rsvp_counts",
      partial: "games/rsvp_counts",
      locals: { game: game, team: team }

    broadcast_replace_to game,
      target: "game_#{game_id}_team_#{team.id}_roster",
      partial: "games/roster",
      locals: { game: game, team: team }
  end
end
