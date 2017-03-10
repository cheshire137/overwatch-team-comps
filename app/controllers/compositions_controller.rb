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
    return @player if @player

    scope = Player.where(name: params[:player_name])
    if user_signed_in?
      scope = scope.where(creator: current_user)
    else
      scope = scope.where(creator: User.anonymous,
                          creator_session_id: session.id)
    end

    @player = scope.first_or_initialize
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
      scope = Composition.where(id: params[:composition_id])

      if user_signed_in?
        scope = scope.where(user_id: current_user)
      else
        scope = scope.where(user_id: User.anonymous, session_id: session.id)
      end

      scope.first
    else
      attrs = {map: map}
      if user_signed_in?
        attrs[:user] = current_user
      else
        attrs[:session_id] = session.id
        attrs[:user] = User.anonymous
      end

      Composition.new(attrs)
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
