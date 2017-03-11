class Player < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User'

  has_many :player_heroes, dependent: :destroy

  validates :name, :creator, presence: true
  validate :creator_session_id_set_if_anonymous

  # Given a list of names for players already in a composition, this will
  # return a reasonable default name for a new player.
  def self.get_name(existing_names)
    existing_default_names = existing_names.uniq.sort.select do |name|
      name =~ /Player \d/
    end
    existing_numbers = existing_default_names.map do |name|
      name.split('Player ')[1].to_i
    end
    default_numbers = [1, 2, 3, 4, 5, 6]
    next_number = (default_numbers - existing_numbers).first
    "Player #{next_number}"
  end

  private

  def creator_session_id_set_if_anonymous
    return unless creator && creator.anonymous?
    return if creator_session_id.present?

    errors.add(:creator_session_id, 'is required if creator is anonymous user.')
  end
end
