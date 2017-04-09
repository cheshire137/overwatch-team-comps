class CompositionRow
  attr_reader :player, :number

  def initialize(number:, player:, builder:)
    @number = number
    @player = player
    @builder = builder
    @heroes_by_segment = {}
  end

  def heroes
    if player
      player.heroes_by_confidence(@builder.heroes)
    else
      @builder.heroes
    end
  end

  def selected_hero(map_segment)
    if @heroes_by_segment.key?(map_segment.id)
      return @heroes_by_segment[map_segment.id]
    end

    unless player
      @heroes_by_segment[map_segment.id] = nil
      return
    end

    selection = @builder.player_selections.detect do |ps|
      ps.map_segment_id == map_segment.id &&
        ps.position == number && ps.player_id == player.id
    end
    @heroes_by_segment[map_segment.id] = selection ? selection.hero_id : nil
  end
end
