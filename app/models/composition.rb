class Composition < ApplicationRecord
  belongs_to :map
  belongs_to :user

  validates :map, presence: true
end
