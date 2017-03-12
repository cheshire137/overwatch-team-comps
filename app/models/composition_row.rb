class CompositionRow
  attr_reader :player, :composition, :number

  def self.for_composition(composition)
    rows = []
    heroes = Hero.order(:name)

    composition.players.each_with_index do |player, i|
      rows << new(number: i, player: player, composition: composition,
                  all_heroes: heroes)
    end

    (rows.length).upto(Composition::MAX_PLAYERS - 1) do |i|
      rows << new(number: i, player: nil, composition: composition,
                  all_heroes: heroes)
    end

    rows
  end

  def initialize(number:, player:, composition:, all_heroes:)
    @number = number
    @player = player
    @composition = composition
    @all_heroes = all_heroes
  end

  def heroes
    if player
      player.heroes_by_confidence(@all_heroes)
    else
      @all_heroes
    end
  end

  def map_segments
    composition.map_segments
  end

  def selected_hero(map_segment)
    return unless player

    selection = PlayerSelection.joins(:composition_player).
      where(map_segment_id: map_segment, composition_players: {
        position: number, player_id: player
      }).first
    selection ? selection.hero_id : nil
  end
end
