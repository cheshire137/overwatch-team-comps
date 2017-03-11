class CompositionSaver
  attr_reader :error_type, :error_value, :composition

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

    if player && data[:hero_id]
      player_hero = init_player_hero(data, player: player)
      unless player_hero.persisted? || player_hero.save
        @error_type = 'player_hero'
        @error_value = player_hero.errors
        return
      end
    end

    if data[:map_segment_id]
      map_segment = MapSegment.find(data[:map_segment_id])
      map = map_segment.map
      @composition = init_composition(data, map: map)
      unless @composition.persisted? || @composition.save
        @error_type = 'composition'
        @error_value = @composition.errors
        return
      end

      if player_hero
        player_selection = init_player_selection(composition: @composition,
                                                 player_hero: player_hero,
                                                 map_segment: map_segment)
        unless player_selection.persisted? || player_selection.save
          @error_type = 'player_selection'
          @error_value = player_selection.errors
          return
        end
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

  def init_player_hero(data, player:)
    hero = Hero.find(data[:hero_id])
    return nil unless hero && player.persisted?
    PlayerHero.where(player_id: player, hero_id: hero).first_or_initialize
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
      Composition.where(id: id, user_id: @user).first
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

  def init_player_selection(composition:, player_hero:, map_segment:)
    if composition.persisted?
      PlayerSelection.where(composition_id: composition,
                            player_hero_id: player_hero,
                            map_segment_id: map_segment).first_or_initialize
    else
      PlayerSelection.new(player_hero: player_hero, map_segment: map_segment)
    end
  end
end