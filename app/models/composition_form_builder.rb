class CompositionFormBuilder
  def initialize(composition)
    @composition = composition
  end

  def rows
    return @rows if @rows
    @rows = []

    # A row for each player already in this composition
    @composition.players.each_with_index do |player, i|
      @rows << CompositionRow.new(number: i, player: player, builder: self)
    end

    # A row for each additional player the user could specify:
    (@rows.length).upto(Composition::MAX_PLAYERS - 1) do |i|
      @rows << CompositionRow.new(number: i, player: nil, builder: self)
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
end
