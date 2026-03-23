class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum :role, { player: 0, captain: 1, admin: 2 }

  validates :user_id, uniqueness: { scope: :team_id }
end
