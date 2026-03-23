class Rsvp < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum :response, { yes: 0, no: 1, maybe: 2 }

  validates :user_id, uniqueness: { scope: :game_id }
  validates :responded_at, presence: true
end
