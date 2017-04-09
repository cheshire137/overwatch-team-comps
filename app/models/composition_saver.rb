class CompositionSaver
  attr_reader :error_type, :error_value, :composition

  class Error < StandardError; end

  def initialize(user:, session_id:)
    @user = user
    @session_id = session_id
  end

  def save(data)
    map = if data[:map_segment_id]
      map_segment = MapSegment.find(data[:map_segment_id])
      map_segment.map
    elsif data[:map_id]
      Map.find(data[:map_id])
    end

    if data[:composition_id] || data[:name] || data[:notes] || map
      @composition = init_composition(data, map: map)
      unless @composition.persisted? && !@composition.changed? || @composition.save
        @error_type = 'composition'
        @error_value = @composition.errors
        return
      end
    end

    position = data[:player_position]

    if data[:player_id] && @composition
      comp_player = init_composition_player(data, position: position,
                                            composition: @composition)
      unless comp_player.persisted? && !comp_player.changed? || comp_player.save
        @error_type = 'composition_player'
        @error_value = comp_player.errors
        return
      end
    end

    if map_segment && comp_player && data[:hero_id]
      selections = init_player_selections(data, composition_player: comp_player,
                                          map_segment: map_segment)
      results = selections.map do |selection|
        selection.persisted? && !selection.changed? || selection.save
      end
      unless results.all?
        @error_type = 'player_selection'
        @error_value = selections.map(&:errors)
        return
      end
    end

    true
  end

  private

  def init_composition_player(data, position:, composition:)
    comp_player = CompositionPlayer.
      where(composition_id: composition, position: position).
      first_or_initialize

    comp_player.player_id = data[:player_id]
    comp_player
  end

  def init_composition(data, map:)
    id = data[:composition_id]

    composition = get_composition_for_user

    if map
      composition.map = map
      composition.slug = nil # will get regenerated based on map
    end

    if (name = data[:name]).present?
      composition.name = name
      composition.slug = nil # will get regenerated based on name
    end

    if (notes = data[:notes]).present?
      composition.notes = notes
    end

    composition
  end

  def get_composition_for_user
    composition = if @user
      composition_for_authenticated_user(id: id)
    else
      composition_for_anonymous_user(id: id)
    end

    unless composition
      raise CompositionSaver::Error, 'No such composition for creator'
    end

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

  def init_player_selections(data, composition_player:, map_segment:)
    hero = Hero.find(data[:hero_id])
    blank_segments = get_blank_segments(map_segment: map_segment,
                                        composition_player: composition_player)

    # All have already been initialized, just need to update the
    # specified map segment for the player to use the given hero.
    if blank_segments.empty?
      update_player_selections(hero: hero, composition_player: composition_player,
                               map_segment: map_segment)
    else
      init_player_selections_for_segments(blank_segments, hero: hero,
                                          composition_player: composition_player)
    end
  end

  def get_blank_segments(composition_player:, map_segment:)
    all_segments = map_segment.map.segment_ids
    filled_segments = composition_player.player_selections.pluck(:map_segment_id)

    all_segments - filled_segments
  end

  def init_player_selections_for_segments(segment_ids, hero:, composition_player:)
    segment_ids.map do |map_segment_id|
      PlayerSelection.new(hero: hero, map_segment_id: map_segment_id,
                          composition_player: composition_player)
    end
  end

  def update_player_selections(hero:, composition_player:, map_segment:)
    updated_selection = PlayerSelection.
      where(composition_player_id: composition_player,
            map_segment_id: map_segment).first
    updated_selection.hero = hero
    [updated_selection]
  end
end
