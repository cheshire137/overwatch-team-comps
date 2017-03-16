class HeroesController < ApplicationController
  before_action :authenticate_user!

  def pool
    @user = current_user
    @heroes = Hero.order(:name)
    @player = current_user.self_player
    @confidence_by_hero_id = @player.player_heroes.
      select(:hero_id, :confidence).
      map { |ph| [ph.hero_id, ph.confidence] }.to_h
  end
end
