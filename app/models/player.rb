# Represents a person in a team composition. Not the same as a user. A user
# is a user of this app. A single user can create multiple players, and will
# have a single player tied to them that represents them in compositions.
class Player < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User'

  has_many :player_heroes, dependent: :destroy
  has_many :composition_players, dependent: :destroy

  validates :name, :creator, presence: true
  validate :creator_session_id_set_if_anonymous
  validate :name_is_unique_to_creator

  scope :order_by_name, ->{ order('UPPER(name) ASC') }

  # Returns a list of Players created by the given User, or by the anonymous
  # user in the given session if the User is nil.
  scope :created_by, ->(user:, session_id:) {
    if user
      where(creator_id: user)
    else
      where(creator_id: User.anonymous, creator_session_id: session_id)
    end
  }

  scope :named, ->(name) { where(name: name) }

  # Returns the Player with the given ID, but only if that Player is
  # owned by the given User/session or if that Player represents the given
  # user.
  #
  # Returns Player or nil.
  def self.find_if_allowed(id, user:, session_id:)
    scope = if user
      where(id: id).where('creator_id = ? OR user_id = ?', user.id, user.id)
    else
      where(id: id, creator_id: User.anonymous, creator_session_id: session_id)
    end

    scope.first
  end

  # Returns the given list of heroes reordered such that the ones the player is most
  # confidence on are first. Sorted secondarily by hero name.
  def heroes_by_confidence(heroes)
    confidence_by_hero_id = PlayerHero.where(player_id: id).
      map { |ph| [ph.hero_id, ph.confidence] }.to_h
    heroes.sort_by do |hero|
      confidence = confidence_by_hero_id[hero.id] || 0
      [-confidence, hero.name]
    end
  end

  private

  def creator_session_id_set_if_anonymous
    return unless creator && creator.anonymous?
    return if creator_session_id.present?

    errors.add(:creator_session_id, 'is required if creator is anonymous user.')
  end

  def name_is_unique_to_creator
    return unless name && creator

    players = self.class.named(name).
      created_by(user: creator, session_id: creator_session_id)
    players = players.where('id <> ?', id) if persisted?

    errors.add(:name, 'has already been taken') if players.count > 0
  end
end
