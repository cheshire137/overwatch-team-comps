class PlayerSelection < ApplicationRecord
  belongs_to :player_hero
  belongs_to :composition
  belongs_to :map_segment

  validates :player_hero, :composition, :map_segment, presence: true
  validates :player_hero_id,
    uniqueness: { scope: [:composition_id, :map_segment_id] }
  validate :map_segment_matches_composition_map

  private

  def map_segment_matches_composition_map
    return unless map_segment && composition

    unless map_segment.map == composition.map
      errors.add(:map_segment, 'must match the composition map.')
    end
  end
end
