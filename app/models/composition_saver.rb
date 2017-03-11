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

    if data[:map_segment_id]
      map_segment = MapSegment.find(data[:map_segment_id])
      map = map_segment.map
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
    if id = data[:player_id]
      scope = Player.where(id: id)
      if @user
        scope = scope.where(creator: @user)
      else
        scope = scope.where(creator: User.anonymous,
                            creator_session_id: @session_id)
      end
      player = scope.first
      unless player
        raise CompositionSaver::Error, 'No such player for creator'
      end
      player.name = data[:player_name]
      player
    else
      attrs = {name: data[:player_name]}
      if @user
        attrs[:creator] = @user
      else
        attrs[:creator] = User.anonymous
        attrs[:creator_session_id] = @session_id
      end
      Player.new(attrs)
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

    if @user
      composition_for_authenticated_user(map: map, id: id)
    else
      composition_for_anonymous_user(map: map, id: id)
    end
  end

  def composition_for_authenticated_user(map:, id:)
    if id
      scope = Composition.where(id: id)
      if @user
        scope = scope.where(user_id: @user)
      else
        scope = scope.where(user_id: User.anonymous, session_id: @session_id)
      end
      comp = scope.first
      unless comp
        raise CompositionSaver::Error, 'No such composition for creator'
      end
      comp.map = map if map
      comp
    else
      Composition.new(map: map, user: @user)
    end
  end

  def composition_for_anonymous_user(map:, id:)
    if id
      Composition.where(id: id, user_id: User.anonymous,
                        session_id: @session_id).first
    else
      Composition.new(map: map, session_id: @session_id,
                      user: User.anonymous)
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
