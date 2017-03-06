class PlayerSelection < ApplicationRecord
  belongs_to :player_hero
  belongs_to :composition

  validates :player_hero, :composition, presence: true
end
