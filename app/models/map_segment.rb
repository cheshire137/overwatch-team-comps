# A particular portion of a map, such as the first capture point or an
# escort segment.
class MapSegment < ApplicationRecord
  belongs_to :map

  validates :map, :name, presence: true
  validates :map_id, uniqueness: { scope: :name }

  # Returns true if this MapSegment is on attack.
  def is_attack?
    name.start_with?('Attack')
  end
end
