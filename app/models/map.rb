class Map < ApplicationRecord
  has_many :segments, class_name: "MapSegment"
end
