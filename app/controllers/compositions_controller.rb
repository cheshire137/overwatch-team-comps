class CompositionsController < ApplicationController
  def new
    @composition = Composition.new(map: Map.first, user: current_user)
    @players = []

    Composition::MAX_PLAYERS.times do |i|
      @players << Player.new(name: "Player #{i + 1}", user: current_user)
    end
  end
end
