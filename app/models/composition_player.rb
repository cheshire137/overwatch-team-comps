class CompositionPlayer < ApplicationRecord
  belongs_to :composition
  belongs_to :player

  before_validation :set_position

  validates :player, :composition, :position, presence: true
  validates :position, numericality: { only_integer: true }

  default_scope { order(:position) }

  private

  def set_position
    self.position ||= composition.composition_players.count
  end
end
