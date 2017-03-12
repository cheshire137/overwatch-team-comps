class CompositionPlayer < ApplicationRecord
  belongs_to :composition
  belongs_to :player

  before_validation :set_position

  validates :player, :composition, :position, presence: true
  validates :position, numericality: { only_integer: true }
  validate :composition_does_not_have_max_players

  default_scope { order(:position) }

  private

  def set_position
    return unless composition

    self.position ||= composition.composition_players.count
  end

  def composition_does_not_have_max_players
    return unless composition

    scope = composition.composition_players
    scope = scope.where('id <> ?', id) if persisted?

    if scope.count > Composition::MAX_PLAYERS - 1
      errors.add(:composition, 'has maximum number of players already.')
    end
  end
end