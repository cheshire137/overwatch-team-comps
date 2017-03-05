class MapSegment < ApplicationRecord
  belongs_to :map

  validates :map, :name, presence: true
end
