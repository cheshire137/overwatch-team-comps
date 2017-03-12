class CompositionRow
  attr_reader :player, :composition, :number

  def self.for_composition(composition)
    rows = []
    heroes = Hero.order(:name)

    player_selections = composition.player_selections.
      select(:map_segment_id, :position, :player_id, :hero_id).to_a

    composition.players.each_with_index do |player, i|
      rows << new(number: i, player: player, composition: composition,
                  all_heroes: heroes, player_selections: player_selections)
    end

    (rows.length).upto(Composition::MAX_PLAYERS - 1) do |i|
      rows << new(number: i, player: nil, composition: composition,
                  all_heroes: heroes, player_selections: player_selections)
    end

    rows
  end

  def initialize(number:, player:, composition:, all_heroes:, player_selections:)
    @number = number
    @player = player
    @composition = composition
    @all_heroes = all_heroes
    @player_selections = player_selections
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

    selection = @player_selections.detect do |ps|
      ps.map_segment_id == map_segment.id &&
        ps.position == number && ps.player_id == player.id
    end
    selection ? selection.hero_id : nil
  end
end
