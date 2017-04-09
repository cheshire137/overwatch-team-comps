class CompositionRow
  attr_reader :player, :number

  def initialize(number:, player:, all_heroes:, player_selections:,
                 heroes_by_segment:)
    @number = number
    @player = player
    @all_heroes = all_heroes
    @selected_heroes = {}
    @heroes_by_segment = heroes_by_segment
    @player_selections = player_selections
  end

  # Returns true if the selected hero for the given map segment is a
  # duplicate pick for another player in the same map segment.
  def duplicate?(map_segment)
    maybe_hero_id = selected_hero(map_segment)
    return false if maybe_hero_id.nil?

    count = @heroes_by_segment[map_segment.id].
      select { |hero_id| hero_id == maybe_hero_id }.size

    count > 1
  end

  # Returns a list of heroes ordered with those the player is most confident
  # on first.
  def heroes
    if player
      player.heroes_by_confidence(@all_heroes)
    else
      @all_heroes
    end
  end

  def selected_hero(map_segment)
    if @selected_heroes.key?(map_segment.id)
      return @selected_heroes[map_segment.id]
    end

    unless player
      @selected_heroes[map_segment.id] = nil
      return
    end

    selection = @player_selections.detect do |player_selection|
      player_selection.position == number &&
        player_selection.map_segment_id == map_segment.id &&
        player_selection.player_id == player.id
    end

    @selected_heroes[map_segment.id] = selection ? selection.hero_id : nil
  end
end
