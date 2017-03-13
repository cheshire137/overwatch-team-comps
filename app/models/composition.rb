class Composition < ApplicationRecord
  MAX_PLAYERS = 6

  belongs_to :map
  belongs_to :user

  has_many :composition_players, dependent: :destroy
  has_many :players, through: :composition_players
  has_many :player_selections, through: :composition_players
  has_many :heroes, through: :player_selections
  has_many :map_segments, through: :map, source: :segments

  before_validation :set_name

  validates :map, :user, :name, presence: true
  validate :session_id_set_if_anonymous
  validate :user_has_not_used_name_before

  scope :anonymous, ->{ where(user_id: User.anonymous) }

  # Returns a list of Compositions created by the given User, or by the anonymous
  # user in the given session if the User is nil.
  scope :created_by, ->(user:, session_id:) {
    if user
      where(user_id: user)
    else
      where(user_id: User.anonymous, session_id: session_id)
    end
  }

  # Returns the most recently saved Composition record for the given User,
  # if any. If the given User is nil, the most recently saved Composition
  # record by the anonymous user with the given session ID will be returned.
  #
  # Returns: Composition or nil
  def self.last_saved(authenticated_user, session_id)
    scope = if authenticated_user
      where(user_id: authenticated_user)
    else
      where(user_id: User.anonymous, session_id: session_id)
    end

    scope.order('updated_at DESC').first
  end

  def available_players(user:, session_id:)
    player_pool = Player.created_by(user: user, session_id: session_id).
      order_by_name
    return player_pool if new_record?

    (player_pool | players).sort_by { |player| player.name.downcase }
  end

  def set_name
    return unless user
    return if name.present?

    num_comps = if user.anonymous?
      self.class.anonymous.where(session_id: session_id).count
    else
      user.compositions.count
    end

    self.name = "Composition #{num_comps + 1}"
  end

  private

  def user_has_not_used_name_before
    return unless user && name

    scope = self.class.where(name: name, user_id: user)
    scope = scope.where(session_id: session_id) if user.anonymous?
    scope = scope.where('id <> ?', id) if persisted?

    if scope.count > 0
      errors.add(:name, 'has already been used for one of your compositions.')
    end
  end

  def session_id_set_if_anonymous
    return unless user && user.anonymous?
    return if session_id.present?

    errors.add(:session_id, 'is required if user is anonymous.')
  end
end
