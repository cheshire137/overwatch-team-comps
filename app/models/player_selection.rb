class PlayerSelection < ApplicationRecord
  belongs_to :player_hero
  belongs_to :composition
  belongs_to :map_segment

  validates :player_hero, :composition, :map_segment, presence: true
  validates :player_hero_id,
    uniqueness: { scope: [:composition_id, :map_segment_id] }
end
