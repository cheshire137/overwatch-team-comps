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
    saver = CompositionSaver.new(user: current_user, session_id: session.id)
    if saver.save(params)
    else
      render json: {
        "#{saver.error_type}_errors" => saver.error_value
      }, status: :unprocessable_entity
    end

    @composition = saver.composition
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

  def new_composition
    map = Map.first

    if user_signed_in?
      Composition.new(map: map, user: current_user)
    else
      Composition.new(map: map, user: User.anonymous, session_id: session.id)
    end
  end
end
