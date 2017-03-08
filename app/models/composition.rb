class Composition < ApplicationRecord
  MAX_PLAYERS = 6

  belongs_to :map
  belongs_to :user

  has_many :player_selections, dependent: :destroy
  has_many :player_heroes, through: :player_selections
  has_many :players, through: :player_heroes
  has_many :heroes, through: :player_heroes

  before_validation :set_name

  validates :map, :session_id, :name, presence: true
  validates :name, uniqueness: { scope: [:map_id, :user_id] }

  def set_name
    return unless user
    return if name.present?

    num_comps = user.compositions.count
    self.name = "Composition #{num_comps + 1}"
  end
end
