class CompositionsController < ApplicationController
  def last_composition
    @composition = Composition.last_saved(current_user, session.id) ||
      new_composition
    @players = get_players_for(@composition)
    @available_players = get_available_players

    heroes = Hero.order(:name)
    @map_segment_ids = get_map_segment_ids(heroes, @composition)
    @heroes_by_player_name = get_heroes_by_player_name(heroes, @players)
    @hero_confidences = get_hero_confidences(heroes, @players)
  end

  def save
    saver = CompositionSaver.new(user: current_user, session_id: session.id)

    success = begin
      saver.save(composition_params)
    rescue CompositionSaver::Error => ex
      return render json: { error: ex.message }, status: :bad_request
    end

    unless success
      return render json: {
        error: {
          saver.error_type => saver.error_value.full_messages
        }
      }, status: :unprocessable_entity
    end

    @composition = saver.composition
    @players = get_players_for(@composition)
    @available_players = get_available_players

    heroes = Hero.order(:name)
    @map_segment_ids = get_map_segment_ids(heroes, @composition)
    @heroes_by_player_name = get_heroes_by_player_name(heroes, @players)
    @hero_confidences = get_hero_confidences(heroes, @players)
  end

  private

  def composition_params
    params.permit(:player_name, :composition_id, :hero_id, :map_segment_id,
                  :player_id, :player_position, :map_id)
  end

  def get_map_segment_ids(heroes, composition)
    result = {}

    heroes.each do |hero|
      result[hero.id] ||= {}
    end

    player_selections = composition.player_selections.
      includes(:player)
    player_selections.each do |player_selection|
      hero_id = player_selection.hero_id
      player_name = player_selection.player.name
      result[hero_id][player_name] ||= []
      result[hero_id][player_name] << player_selection.map_segment_id
    end

    result
  end

  # Returns a list of Players the current user has created and can choose
  # from for filling out a team composition.
  def get_available_players
    Player.created_by(user: current_user, session_id: session.id).
           order_by_name
  end

  def get_players_for(composition)
    players = []
    players.concat(composition.players) if composition.persisted?

    existing_names = players.pluck(:name)
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
