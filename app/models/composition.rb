# A team composition. An arrangement of players and the heroes they play
# for each map segment in the selected map.
class Composition < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

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

  # Returns compositions created by the given User/session with the most
  # recently modified first.
  scope :most_recent, ->(user:, session_id:) {
    created_by(user: user, session_id: session_id).order('updated_at DESC')
  }

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

  def map_name
    map.try(:name)
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      %i[map_name name]
    ]
  end

  # Returns true if this Composition is owned by the given user.
  def mine?(user:, session_id:)
    if user
      self.user == user
    else
      self.user.anonymous? && self.session_id == session_id
    end
  end

  # Updates this Composition's updated_at if it belongs to the given user.
  def touch_if_mine(user:, session_id:)
    return unless mine?(user: user, session_id: session_id)

    touch
  end

  private

  def user_has_not_used_name_before
    return unless user && name

    compositions = self.class.where(name: name, user_id: user)
    compositions = compositions.where(session_id: session_id) if user.anonymous?
    compositions = compositions.where('id <> ?', id) if persisted?
    return if compositions.count <= 0

    errors.add(:name, 'has already been used for one of your compositions')
  end

  def session_id_set_if_anonymous
    return unless user && user.anonymous?
    return if session_id.present?

    errors.add(:session_id, 'is required if user is anonymous.')
  end
end
