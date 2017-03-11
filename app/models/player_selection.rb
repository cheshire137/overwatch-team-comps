class PlayerSelection < ApplicationRecord
  belongs_to :player
  belongs_to :hero
  belongs_to :composition
  belongs_to :map_segment

  validates :player, :hero, :composition, :map_segment, presence: true
  validates :player_id,
    uniqueness: { scope: [:composition_id, :map_segment_id] }
  validate :map_segment_matches_composition_map
  validate :player_is_in_composition

  private

  def map_segment_matches_composition_map
    return unless map_segment && composition

    unless map_segment.map == composition.map
      errors.add(:map_segment, 'must match the composition map.')
    end
  end

  def player_is_in_composition
    return unless player && composition

    unless composition.players.include?(player)
      errors.add(:player, 'is not part of the composition.')
    end
  end
end
