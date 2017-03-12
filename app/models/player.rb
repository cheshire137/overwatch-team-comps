class Player < ApplicationRecord
  DEFAULT_NAME = 'Player'.freeze

  belongs_to :user
  belongs_to :creator, class_name: 'User'

  has_many :player_heroes, dependent: :destroy

  validates :name, :creator, presence: true
  validate :creator_session_id_set_if_anonymous
  validate :name_is_unique_to_creator

  # Returns a list of Players created by the given User, or by the anonymous
  # user in the given session if the User is nil.
  scope :created_by, ->(user:, session_id:) {
    if user
      where(creator_id: user)
    else
      where(creator_id: User.anonymous, creator_session_id: session_id)
    end
  }

  scope :not_default_name, ->{ where('name NOT IN (?)', DEFAULT_NAMES) }

  scope :order_by_name, ->{ order('UPPER(name) ASC') }

  # Returns the 'default' player for use when a user selects a hero first
  # before choosing a player.
  def self.default
    find_by_name DEFAULT_NAME
  end

  def default?
    name == DEFAULT_NAME
  end

  # Returns the given list of heroes reordered such that the ones the player is most
  # confidence on are first. Sorted secondarily by hero name.
  def heroes_by_confidence(heroes)
    confidence_by_hero_id = PlayerHero.where(player_id: id).order('confidence DESC').
      map { |ph| [ph.hero_id, ph.confidence] }.to_h
    heroes.sort_by do |hero|
      confidence = confidence_by_hero_id[hero.id] || 0
      [confidence, hero.name]
    end
  end

  private

  def creator_session_id_set_if_anonymous
    return unless creator && creator.anonymous?
    return if creator_session_id.present?
    return if default? # don't care about session for 'default' Player

    errors.add(:creator_session_id, 'is required if creator is anonymous user.')
  end

  def name_is_unique_to_creator
    return unless name && creator

    scope = self.class.where(name: name, creator_id: creator)

    if creator.anonymous?
      scope = scope.where(creator_session_id: creator_session_id)
    end

    scope = scope.where('id <> ?', id) if persisted?

    if scope.count > 0
      errors.add(:name, 'has already been taken.')
    end
  end
end
