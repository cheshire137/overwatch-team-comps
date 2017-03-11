class Player < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User'

  has_many :player_heroes, dependent: :destroy

  validates :name, :creator, presence: true
  validate :creator_session_id_set_if_anonymous

  private

  def creator_session_id_set_if_anonymous
    return unless creator && creator.anonymous?
    return if creator_session_id.present?

    errors.add(:creator_session_id, 'is required if creator is anonymous user.')
  end
end
