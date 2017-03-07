class Player < ApplicationRecord
  belongs_to :user

  has_many :player_heroes

  validates :name, presence: true
end
