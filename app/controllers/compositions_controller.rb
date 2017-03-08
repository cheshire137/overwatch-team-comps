class CompositionsController < ApplicationController
  def new
    @composition = Composition.new(map: Map.first, user: current_user)
    @players = []

    Composition::MAX_PLAYERS.times do |i|
      @players << Player.new(name: "Player #{i + 1}", user: current_user)
    end

    heroes = Hero.order(:name)
    heroes.each do |hero|
      @players.each do |player|
        player.player_heroes << PlayerHero.new(player: player, hero: hero)
      end
    end
  end
end
