class Player < ApplicationRecord
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

  scope :order_by_name, ->{ order('UPPER(name) ASC') }

  # Given a list of names for players already in a composition, this will
  # return a reasonable default name for a new player.
  def self.get_name(existing_names)
    existing_default_names = existing_names.uniq.sort.select do |name|
      name =~ /Player \d/
    end
    existing_numbers = existing_default_names.map do |name|
      name.split('Player ')[1].to_i
    end
    default_numbers = [1, 2, 3, 4, 5, 6]
    next_number = (default_numbers - existing_numbers).first
    "Player #{next_number}"
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
