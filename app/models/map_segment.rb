class MapSegment < ApplicationRecord
  belongs_to :map

  validates :map, :name, presence: true
  validates :map_id, uniqueness: { scope: :name }

  # Returns true if this MapSegment is on attack.
  def is_attack?
    name.start_with?('Attack')
  end
end
