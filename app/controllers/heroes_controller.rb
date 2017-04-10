# Requires the user be logged in. For rendering and updating an authenticated
# user's hero pool, that is, how confident they feel playing each hero.
class HeroesController < ApplicationController
  before_action :authenticate_user!

  def pool
    @user = current_user
    @heroes = Hero.order(:name)
    @player = current_user.self_player
    @confidence_by_hero_id = get_confidence_by_hero_id(@player)
  end

  def save
    @player = current_user.self_player
    player_hero = PlayerHero.
      where(player_id: @player, hero_id: params[:hero_id]).
      first_or_initialize
    player_hero.confidence = params[:confidence]

    unless player_hero.save
      return render json: { error: { player_hero: player_hero.errors } },
                    status: :unprocessable_entity
    end

    @user = current_user
    @heroes = Hero.order(:name)
    @confidence_by_hero_id = get_confidence_by_hero_id(@player)
    render template: 'heroes/pool'
  end

  private

  def get_confidence_by_hero_id(player)
    player.player_heroes.select(:hero_id, :confidence).
      map { |ph| [ph.hero_id, ph.confidence] }.to_h
  end
end
