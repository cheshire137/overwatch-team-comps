class CompositionSaver
  attr_reader :error_type, :error_value, :composition

  class Error < StandardError; end

  def initialize(user:, session_id:)
    @user = user
    @session_id = session_id
  end

  def save(data)
    if data[:player_id] || data[:player_name]
      player = init_player(data)
      unless player.persisted? && !player.changed? || player.save
        @error_type = 'player'
        @error_value = player.errors
        return
      end
    end

    map = if data[:map_segment_id]
      map_segment = MapSegment.find(data[:map_segment_id])
      map_segment.map
    elsif data[:map_id]
      Map.find(data[:map_id])
    end

    if data[:composition_id] || map
      @composition = init_composition(data, map: map)
      unless @composition.persisted? || @composition.save
        @error_type = 'composition'
        @error_value = @composition.errors
        return
      end
    end

    if player && @composition
      comp_player = init_composition_player(data, player: player,
                                            composition: @composition)
      unless comp_player.persisted? || comp_player.save
        @error_type = 'composition_player'
        @error_value = comp_player.errors
        return
      end
    end

    if player && map_segment && data[:hero_id]
      selection = init_player_selection(data, composition: @composition,
                                        player: player, map_segment: map_segment)
      unless selection.persisted? && !selection.changed? || selection.save
        @error_type = 'player_selection'
        @error_value = selection.errors
        return
      end
    end

    true
  end

  private

  def init_player(data)
    id = data[:player_id]
    name = data[:player_name]

    player = if @user
      player_for_authenticated_user(id: id, name: name)
    else
      player_for_anonymous_user(id: id, name: name)
    end

    unless player
      raise CompositionSaver::Error, 'No such player for creator'
    end

    player.name = name if name
    player
  end

  def player_for_authenticated_user(id:, name:)
    if id
      Player.where(creator_id: @user, id: id).first
    elsif name
      Player.where(creator_id: @user, name: name).first_or_initialize
    else
      Player.new(creator: @user)
    end
  end

  def player_for_anonymous_user(id:, name:)
    if id
      Player.where(creator_id: User.anonymous, id: id,
                   creator_session_id: @session_id).first
    elsif name
      Player.where(creator_id: User.anonymous, name: name,
                   creator_session_id: @session_id).first_or_initialize
    else
      Player.new(creator: User.anonymous,
                 creator_session_id: @session_id)
    end
  end

  def init_composition_player(data, player:, composition:)
    comp_player = CompositionPlayer.where(composition_id: composition,
                                          player_id: player).
                                    first_or_initialize
    comp_player.position = data[:player_position] if data[:player_position]
    comp_player
  end

  def init_composition(data, map:)
    id = data[:composition_id]

    composition = if @user
      composition_for_authenticated_user(id: id)
    else
      composition_for_anonymous_user(id: id)
    end

    unless composition
      raise CompositionSaver::Error, 'No such composition for creator'
    end

    composition.map = map if map
    composition
  end

  def composition_for_authenticated_user(id:)
    if id
      Composition.where(user: @user, id: id).first
    else
      Composition.new(user: @user)
    end
  end

  def composition_for_anonymous_user(id:)
    if id
      Composition.where(id: id, user_id: User.anonymous,
                        session_id: @session_id).first
    else
      Composition.new(session_id: @session_id, user: User.anonymous)
    end
  end

  def init_player_selection(data, composition:, player:, map_segment:)
    hero = Hero.find(data[:hero_id])

    if composition.persisted?
      selection = PlayerSelection.
        where(composition_id: composition, player_id: player,
              map_segment_id: map_segment).first_or_initialize
      selection.hero = hero
      selection
    else
      PlayerSelection.new(player: player, hero: hero, map_segment: map_segment,
                          composition: composition)
    end
  end
end
