class Map < ApplicationRecord
  extend FriendlyId

  has_many :segments, dependent: :destroy, class_name: "MapSegment"

  validates :name, presence: true, uniqueness: true

  friendly_id :name, use: :slugged
end
