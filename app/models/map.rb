class Map < ApplicationRecord
  has_many :segments, dependent: :destroy, class_name: "MapSegment"

  validates :name, presence: true, uniqueness: true
end
