class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :registerable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:bnet]

  has_many :compositions, dependent: :destroy
  has_many :created_players, class_name: 'Player', foreign_key: 'creator_id'

  ANONYMOUS_EMAIL = 'anonymous@overwatch-team-comps.com'.freeze

  # Returns the special User for representing anonymous site visitors.
  def self.anonymous
    find_by_email ANONYMOUS_EMAIL
  end

  # Returns true if this User is the special User that represents an anonymous visitor
  # to the site.
  def anonymous?
    email == ANONYMOUS_EMAIL
  end
end
