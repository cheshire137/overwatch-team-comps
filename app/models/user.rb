class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :database_authenticatable, :recoverable, :confirmable, :lockable, :registerable,
  # :timeoutable and :omniauthable
  devise :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:bnet]
end
