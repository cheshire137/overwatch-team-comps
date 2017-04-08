class Map < ApplicationRecord
  extend FriendlyId

  has_many :segments, dependent: :destroy, class_name: "MapSegment"
  has_many :compositions, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  friendly_id :name, use: :slugged

  def image_name
    @image_name ||= "#{slug}.png"
  end
end
