# A player in a team composition. Has a unique numeric position, meaning
# the row they're in. Has many selections, one per map segment for the
# composition's selected map.
class CompositionPlayer < ApplicationRecord
  belongs_to :composition
  belongs_to :player

  has_many :player_selections, dependent: :destroy

  before_validation :set_position
  after_destroy :decrement_positions

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

    comp_players = composition.composition_players
    comp_players = comp_players.where('id <> ?', id) if persisted?
    return if comp_players.count <= Composition::MAX_PLAYERS - 1

    errors.add(:composition, 'has maximum number of players already')
  end

  def player_is_allowed_for_comp_owner
    return unless player && composition

    if player.creator.anonymous?
      player_is_allowed_for_anonymous_creator
    else
      player_is_allowed_for_registered_creator
    end
  end

  def player_is_allowed_for_anonymous_creator
    unless composition.user.anonymous? &&
           composition.session_id == player.creator_session_id
      errors.add(:player, 'is not valid')
    end
  end

  def player_is_allowed_for_registered_creator
    return if composition.user == player.creator

    errors.add(:player, 'is not valid')
  end

  def decrement_positions
    composition.composition_players.where('position >= ?', position).
      update_all('position = position - 1')
  end
end
