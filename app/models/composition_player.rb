class CompositionPlayer < ApplicationRecord
  belongs_to :composition
  belongs_to :player

  has_many :player_selections, dependent: :destroy

  before_validation :set_position

  validates :player, :composition, :position, presence: true
  validates :position, numericality: { only_integer: true },
    inclusion: 0...Composition::MAX_PLAYERS
  validates :player_id, uniqueness: { scope: :composition_id }
  validate :composition_does_not_have_max_players
  validate :player_is_allowed_for_comp_owner

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

  def player_is_allowed_for_comp_owner
    return unless player && composition

    if player.creator.anonymous?
      unless composition.user.anonymous? &&
             composition.session_id == player.creator_session_id
        errors.add(:player, 'is not valid.')
      end
    else
      unless composition.user == player.creator
        errors.add(:player, 'is not valid.')
      end
    end
  end
end
