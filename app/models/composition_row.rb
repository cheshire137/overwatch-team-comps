class CompositionRow
  attr_reader :player, :number

  def initialize(number:, player:, builder:)
    @number = number
    @player = player
    @builder = builder
  end

  def heroes
    if player
      player.heroes_by_confidence(@builder.heroes)
    else
      @builder.heroes
    end
  end

  def selected_hero(map_segment)
    return unless player

    selection = @builder.player_selections.detect do |ps|
      ps.map_segment_id == map_segment.id &&
        ps.position == number && ps.player_id == player.id
    end
    selection ? selection.hero_id : nil
  end
end
