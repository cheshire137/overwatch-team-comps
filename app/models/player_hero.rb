class PlayerHero < ApplicationRecord
  belongs_to :player
  belongs_to :hero

  validates :player, :hero, presence: true
  validates :confidence, numericality: { only_integer: true }
end
