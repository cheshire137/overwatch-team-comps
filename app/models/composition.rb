class Composition < ApplicationRecord
  MAX_PLAYERS = 6

  belongs_to :map
  belongs_to :user

  has_many :player_selections
  has_many :player_heroes, through: :player_selections
  has_many :players, through: :player_heroes
  has_many :heroes, through: :player_heroes

  validates :map, presence: true
end
