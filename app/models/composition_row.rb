class CompositionRow
  attr_reader :player, :composition, :number

  def self.for_composition(composition)
    rows = []
    heroes = Hero.order(:name)

    composition.players.each_with_index do |player, i|
      rows << new(number: i, player: player, composition: composition,
                  all_heroes: heroes)
    end

    default_player = Player.default
    (rows.length).upto(Composition::MAX_PLAYERS - 1) do |i|
      rows << new(number: i, player: default_player, composition: composition,
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
    if player.default?
      @all_heroes
    else
      player.heroes_by_confidence(@all_heroes)
    end
  end

  def hero_confidence(hero)
    return 0 if player.default?

    # TODO: remove n+1 query by prefetching player-hero records
    player_hero = PlayerHero.where(player_id: player, hero_id: hero).first
    player_hero ? player_hero.confidence : 0
  end

  def map_segments
    composition.map_segments
  end

  def selected_hero(map_segment)
    selection = PlayerSelection.joins(:composition_player).
      where(map_segment_id: map_segment, composition_players: {
        position: number, player_id: player
      }).first
    selection ? selection.hero_id : nil
  end
end
