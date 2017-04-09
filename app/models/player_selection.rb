class PlayerSelection < ApplicationRecord
  belongs_to :composition_player
  belongs_to :hero
  belongs_to :map_segment

  has_one :composition, through: :composition_player
  has_one :player, through: :composition_player
  has_one :map, through: :map_segment

  validates :composition_player, :hero, :map_segment, presence: true
  validates :composition_player_id, uniqueness: { scope: :map_segment_id }
  validate :map_segment_matches_composition_map

  private

  def map_segment_matches_composition_map
    return unless map && composition

    unless map == composition.map
      errors.add(:map_segment, 'must match the composition map.')
    end
  end
end
