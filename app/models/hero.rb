class Hero < ApplicationRecord
  validates :name, presence: true
end
