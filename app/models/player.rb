class Player < ApplicationRecord
  belongs_to :user

  has_many :player_heroes, dependent: :destroy

  validates :name, presence: true
end
