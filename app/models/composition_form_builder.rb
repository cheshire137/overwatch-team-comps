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

  def player_selections
    @player_selections ||= @composition.player_selections.
      select(:map_segment_id, :position, :player_id, :hero_id).to_a
  end
end
