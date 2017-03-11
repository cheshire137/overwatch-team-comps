class Composition < ApplicationRecord
  MAX_PLAYERS = 6

  belongs_to :map
  belongs_to :user

  has_many :player_selections, dependent: :destroy
  has_many :player_heroes, through: :player_selections
  has_many :players, through: :player_heroes
  has_many :heroes, through: :player_heroes

  before_validation :set_name

  validates :map, :user, :name, presence: true
  validate :session_id_set_if_anonymous
  validate :user_has_not_used_name_before

  scope :anonymous, ->{ where(user_id: User.anonymous) }

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
