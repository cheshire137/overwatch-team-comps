class Map < ApplicationRecord
  has_many :segments, class_name: "MapSegment"

  validates :name, presence: true, uniqueness: true
end
