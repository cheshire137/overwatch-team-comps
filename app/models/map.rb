class Map < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
