class CompositionsController < ApplicationController
  def last_composition
    @composition = Composition.last_saved(current_user, session.id) ||
      new_composition
    @players = get_players_for(@composition)

    heroes = Hero.order(:name)
    @map_segment_ids = get_map_segment_ids(heroes, @composition)
    @heroes_by_player_name = get_heroes_by_player_name(heroes, @players)
    @hero_confidences = get_hero_confidences(heroes, @players)
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
    @players = get_players_for(@composition)

    heroes = Hero.order(:name)
    @map_segment_ids = get_map_segment_ids(heroes, @composition)
    @heroes_by_player_name = get_heroes_by_player_name(heroes, @players)
    @hero_confidences = get_hero_confidences(heroes, @players)
  end

  private

  def get_map_segment_ids(heroes, composition)
    result = {}

    heroes.each do |hero|
      result[hero.id] ||= {}
    end

    player_selections = composition.player_selections.
      includes(player_hero: :player)
    player_selections.each do |player_selection|
      hero_id = player_selection.player_hero.hero_id
      player_name = player_selection.player_hero.player.name
      result[hero_id][player_name] = player_selection.map_segment_id
    end

    result
  end

  def get_players_for(composition)
    players = []
    players.concat(composition.players.uniq) if composition.persisted?

    existing_names = players.map(&:name)
    while players.length < Composition::MAX_PLAYERS
      name = Player.get_name(existing_names)
      players << Player.new(name: name)
      existing_names << name
    end

    players
  end

  # Returns a hash with hero IDs as keys and another hash as the value. The
  # nested hash has player names as keys and the confidence of each player
  # for that hero as the value.
  def get_hero_confidences(heroes, players)
    result = {}
    saved_players = players.select { |p| p.persisted? }
    player_heroes = PlayerHero.includes(:player).
      where(hero_id: heroes, player_id: saved_players).
      map { |ph| [ph.player.name, ph.confidence] }.to_h

    heroes.each do |hero|
      result[hero.id] ||= {}
      players.each do |player|
        result[hero.id][player.name] = player_heroes[player.name] || 0
      end
    end

    result
  end

  def get_heroes_by_player_name(heroes, players)
    result = {}

    players.each do |player|
      result[player.name] ||= []

      if player.persisted?
        result[player.name] = player.heroes_by_confidence(heroes)
      else
        result[player.name] = heroes
      end
    end

    result
  end

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

  def new_composition
    map = Map.first

    if user_signed_in?
      Composition.new(map: map, user: current_user)
    else
      Composition.new(map: map, user: User.anonymous, session_id: session.id)
    end
  end

  def composition
    return @composition if defined? @composition

    @composition = if user_signed_in?
      composition_for_authenticated_user
    else
      composition_for_anonymous_user
    end
  end

  def composition_for_authenticated_user
    if id = params[:composition_id]
      Composition.where(id: id, user_id: current_user).first
    else
      Composition.new(map: map, user: current_user)
    end
  end

  def composition_for_anonymous_user
    if id = params[:composition_id]
      Composition.where(id: id, user_id: User.anonymous,
                        session_id: session.id).first
    else
      Composition.new(map: map, session_id: session.id, user: User.anonymous)
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
