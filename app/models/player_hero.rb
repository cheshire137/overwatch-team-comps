# Connects a player to a hero with a particular confidence, representing
# how well the player thinks they play that hero.
class PlayerHero < ApplicationRecord
  belongs_to :player
  belongs_to :hero

  validates :player, :hero, presence: true
  validates :confidence, numericality: { only_integer: true }
  validates :player_id, uniqueness: { scope: :hero_id }
end
