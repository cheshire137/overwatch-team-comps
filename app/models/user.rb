class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :registerable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:bnet]

  has_many :compositions, dependent: :destroy

  def self.anonymous
    find_by_email "anonymous@overwatch-team-comps.com"
  end
end
