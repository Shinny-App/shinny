class Rsvp < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum :response, { yes: 0, no: 1, maybe: 2 }

  validates :user_id, uniqueness: { scope: :game_id }
  validates :responded_at, presence: true

  after_save_commit :broadcast_rsvp_update

  private

  def broadcast_rsvp_update
    broadcast_replace_to game,
      target: "game_#{game_id}_rsvp_counts",
      partial: "games/rsvp_counts",
      locals: { game: game, team: game.user_team(user) }

    broadcast_replace_to game,
      target: "game_#{game_id}_roster",
      partial: "games/roster",
      locals: { game: game, team: game.user_team(user) }
  end
end
