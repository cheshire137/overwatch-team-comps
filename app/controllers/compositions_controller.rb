class CompositionsController < ApplicationController
  def new
    @composition = Composition.new
    @composition.map = Map.first
    6.times do |i|
      player = Player.new(name: "Player #{i + 1}")
      player_hero = PlayerHero.new(player: player)
      @composition.player_selections << PlayerSelection.new(player_hero: player_hero,
                                                            composition: @composition)
    end
  end
end
