class Team < ApplicationRecord
  belongs_to :league
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates :name, presence: true
end
