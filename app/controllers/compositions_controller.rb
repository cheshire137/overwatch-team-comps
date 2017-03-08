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

  def create
    unless player.persisted? || player.save
      return render json: { player_errors: player.errors },
                    status: :unprocessable_entity
    end

    unless player_hero.persisted? || player_hero.save
      return render json: { player_hero_errors: player_hero.errors },
                    status: :unprocessable_entity
    end

    unless composition.save
      return render json: { composition_errors: composition.errors },
                    status: :unprocessable_entity
    end

    unless player_selection.persisted? || player_selection.save
      return render json: { player_selection_errors: player_selection.errors },
                    status: :unprocessable_entity
    end

    @players = composition.players.includes(:player_heroes)
  end

  private

  def player
    return @player if @player
    @player = Player.where(name: params[:player_name])
    @player = @player.where(user_id: current_user) if user_signed_in?
    @player = @player.first_or_initialize
  end

  def hero
    return @hero if defined? @hero
    @hero = Hero.find(params[:hero_id])
  end

  def player_hero
    return @player_hero if @player_hero
    return @player_hero = nil unless hero && player.persisted?

    @player_hero = PlayerHero.where(player_id: player, hero_id: hero).
      first_or_initialize
  end

  def map
    return @map if defined? @map
    @map = Map.find(params[:map_id])
  end

  def composition
    @composition ||= Composition.new(map: map, user: current_user)
  end

  def player_selection
    @player_selection ||= PlayerSelection.
      where(composition_id: composition, player_hero_id: player_hero).
      first_or_initialize
  end
end
