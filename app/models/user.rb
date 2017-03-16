class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :registerable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:bnet]

  has_many :compositions, dependent: :destroy
  has_many :created_players, class_name: 'Player', foreign_key: 'creator_id'

  ANONYMOUS_EMAIL = 'anonymous@overwatch-team-comps.com'.freeze

  alias_attribute :to_s, :email

  # Returns the special User for representing anonymous site visitors.
  def self.anonymous
    find_by_email ANONYMOUS_EMAIL
  end

  # The Player that represents this User.
  def self_player
    player = Player.where(user_id: id).first_or_initialize
    if player.new_record?
      player.name = battletag
      player.creator_id = id
      player.save
    end
    player
  end

  # Returns true if this User is the special User that represents an anonymous visitor
  # to the site.
  def anonymous?
    email == ANONYMOUS_EMAIL
  end

  def migrate_session_records(session_id)
    Player.where(creator_id: self.class.anonymous,
                 creator_session_id: session_id).update_all(creator_id: id)
    Composition.where(user_id: self.class.anonymous,
                      session_id: session_id).update_all(user_id: id)
  end
end
