class CompositionsController < ApplicationController
  def last_composition
    @composition = Composition.last_saved(current_user, session.id) ||
      new_composition
    @rows = CompositionRow.for_composition(@composition)
    @available_players = get_available_players(@composition)
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
    @rows = CompositionRow.for_composition(@composition)
    @available_players = get_available_players(@composition)
  end

  private

  def composition_params
    params.permit(:player_name, :composition_id, :hero_id, :map_segment_id,
                  :player_id, :player_position, :map_id)
  end

  def get_map_segment_ids(heroes, composition, players)
    result = {}

    # Ensure all 6 players are represented and each player has a slot for
    # each hero.
    players.each do |player|
      result[player.id] ||= {}

      heroes.each do |hero|
        result[player.id][hero.id] = []
      end
    end

    player_selections = composition.player_selections.
      includes(:composition_player)
    player_selections.each do |player_selection|
      hero_id = player_selection.hero_id
      player_id = player_selection.composition_player.player_id

      result[player_id][hero_id] << player_selection.map_segment_id
    end

    result
  end

  # Returns a list of Players the current user has created and can choose
  # from for filling out a team composition.
  def get_available_players(composition)
    player_pool = Player.created_by(user: current_user, session_id: session.id)
    players_in_comp = composition.players.not_default
    (player_pool | players_in_comp).sort_by { |player| player.name.downcase }
  end

  # Returns a hash with hero IDs as keys and another hash as the value. The
  # nested hash has player names as keys and the confidence of each player
  # for that hero as the value.
  def get_hero_confidences(heroes, players)
    result = {}

    players.each do |player|
      result[player.id] = Hash.new(0)
    end

    player_heroes = PlayerHero.where(hero_id: heroes, player_id: players)
    player_heroes.each do |player_hero|
      result[player_hero.player_id][player_hero.hero_id] = player_hero.confidence
    end

    result
  end

  def get_heroes_by_player(heroes, players)
    result = {}

    players.each do |player|
      result[player.id] ||= []

      if player.default?
        result[player.id] = heroes
      else
        result[player.id] = player.heroes_by_confidence(heroes)
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
