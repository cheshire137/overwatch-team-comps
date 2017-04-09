# Used to construct JSON data for the front end to consume to display the
# composition form. Has many rows, one per player. The columns are for
# each map segment in the composition's selected map.
class CompositionFormBuilder
  def initialize(composition)
    @composition = composition
    @heroes_by_segment = get_heroes_by_segment
  end

  # Returns true if there are any duplicate hero selections in a given column,
  # that is, for a given map segment.
  def any_duplicates?
    return @any_duplicates if defined? @any_duplicates

    @any_duplicates = @heroes_by_segment.any? do |_, hero_ids|
      hero_ids.uniq.size != hero_ids.size
    end
  end

  def rows
    return @rows if @rows
    @rows = []
    all_heroes = heroes

    # A row for each player already in this composition
    @composition.players.each_with_index do |player, i|
      @rows << CompositionRow.new(number: i, player: player,
                                  all_heroes: all_heroes,
                                  player_selections: player_selections,
                                  heroes_by_segment: @heroes_by_segment)
    end

    # A row for each additional player the user could specify:
    @rows.length.upto(Composition::MAX_PLAYERS - 1) do |i|
      @rows << CompositionRow.new(number: i, player: nil,
                                  all_heroes: all_heroes,
                                  player_selections: player_selections,
                                  heroes_by_segment: @heroes_by_segment)
    end

    @rows
  end

  def heroes
    @heroes ||= Hero.order(:name)
  end

  def map_segments
    @map_segments ||= @composition.map_segments
  end

  # Returns true if the given MapSegment is fully populated with
  # player+hero assignments.
  def map_segment_filled?(map_segment)
    player_selections.
      select { |ps| ps.map_segment_id == map_segment.id }.size >= 6
  end

  # Returns true if the given MapSegment is the first one of its type
  # (attack v. defense) in the list of map segments.
  def map_segment_is_first_of_kind?(map_segment)
    index = map_segments.index(map_segment)
    return true if index == 0
    prev_map_segment = map_segments[index - 1]
    prev_map_segment.is_attack? != map_segment.is_attack?
  end

  # Returns true if the given MapSegment is the last one of its type
  # (attack v. defense) in the list of map segments.
  def map_segment_is_last_of_kind?(map_segment)
    index = map_segments.index(map_segment)
    return true if index == map_segments.length - 1
    next_map_segment = map_segments[index + 1]
    next_map_segment.is_attack? != map_segment.is_attack?
  end

  def player_selections
    @player_selections ||= @composition.player_selections.
      select(:map_segment_id, :position, :player_id, :hero_id).to_a
  end

  private

  # Returns a hash: map segment ID => array of hero IDs
  def get_heroes_by_segment
    result = {}

    player_selections.each do |player_selection|
      result[player_selection.map_segment_id] ||= []
      result[player_selection.map_segment_id] << player_selection.hero_id
    end

    result
  end
end
