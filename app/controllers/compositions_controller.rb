class CompositionsController < ApplicationController
  def new
    @composition = Composition.new(map: Map.first, user: current_user)
    @players = []

    Composition::MAX_PLAYERS.times do |i|
      player = Player.new(name: "Player #{i + 1}", user: current_user)
      @players << player

      player_hero = PlayerHero.new(player: player)
      @composition.player_selections << PlayerSelection.new(
        player_hero: player_hero, composition: @composition
      )
    end
  end
end
