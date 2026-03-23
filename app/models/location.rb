class Location < ApplicationRecord
  belongs_to :league

  validates :name, presence: true
end
