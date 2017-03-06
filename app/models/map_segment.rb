class MapSegment < ApplicationRecord
  belongs_to :map

  validates :map, :name, presence: true
  validates :map_id, uniqueness: { scope: :name }
end
