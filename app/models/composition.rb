class Composition < ApplicationRecord
  MAX_PLAYERS = 6

  belongs_to :map
  belongs_to :user

  has_many :player_selections
  has_many :player_heroes, through: :player_selections
  has_many :players, through: :player_heroes
  has_many :heroes, through: :player_heroes

  validates :map, presence: true

  def self.build_new(user:, map:)
    comp = Composition.new(map: map)

    MAX_PLAYERS.times do |i|
      player = Player.new(name: "Player #{i + 1}", user: user)
      player_hero = PlayerHero.new(player: player)
      comp.player_selections << PlayerSelection.new(
        player_hero: player_hero, composition: comp
      )
    end

    comp
  end
end
