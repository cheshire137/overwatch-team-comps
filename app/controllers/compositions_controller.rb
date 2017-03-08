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

  def save
    unless player.persisted? || player.save
      return render json: { player_errors: player.errors },
                    status: :unprocessable_entity
    end

    unless player_hero.persisted? || player_hero.save
      return render json: { player_hero_errors: player_hero.errors },
                    status: :unprocessable_entity
    end

    unless composition.persisted? || composition.save
      return render json: { composition_errors: composition.errors },
                    status: :unprocessable_entity
    end

    unless player_selection.persisted? || player_selection.save
      return render json: { player_selection_errors: player_selection.errors },
                    status: :unprocessable_entity
    end

    @composition = composition
    @map = map
    @player_selection = player_selection
    @players = @composition.players.includes(:player_heroes)
  end

  private

  def player
    @player ||= Player.where(name: params[:player_name]).first_or_initialize
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

  def map_segment
    return @map_segment if defined? @map_segment
    @map_segment = MapSegment.find(params[:map_segment_id])
  end

  def map
    return @map if defined? @map
    @map = if map_segment
      map_segment.map
    end
  end

  def composition
    return @composition if defined? @composition
    @composition = if params[:composition_id]
      Composition.where(id: params[:composition_id], user: current_user).first
    else
      Composition.new(map: map, user: current_user)
    end
  end

  def player_selection
    @player_selection ||= if composition.persisted?
      PlayerSelection.where(composition_id: composition,
                            player_hero_id: player_hero,
                            map_segment_id: map_segment).first_or_initialize
    else
      PlayerSelection.new(player_hero: player_hero, map_segment: map_segment)
    end
  end
end
