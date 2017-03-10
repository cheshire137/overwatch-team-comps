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
  validates :name, uniqueness: { scope: [:map_id, :user_id] }
  validate :session_id_set_if_anonymous

  def set_name
    return unless user
    return if name.present?

    num_comps = if user.anonymous?
      Composition.where(session_id: session_id).count
    else
      user.compositions.count
    end

    self.name = "Composition #{num_comps + 1}"
  end

  private

  def session_id_set_if_anonymous
    return unless user && user.anonymous?
    return if session_id.present?

    errors.add(:session_id, 'is required if user is anonymous.')
  end
end
