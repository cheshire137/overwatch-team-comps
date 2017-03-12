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
    @all_heroes
  end

  def hero_confidence(hero)
    return 0 if player.default?

    # TODO: remove n+1 query by prefetching player-hero records
    player_hero = PlayerHero.where(player_id: player, hero_id: hero).first
    player_hero ? player_hero.confidence : 0
  end

  # Returns an array of MapSegment IDs where the given Hero is selected
  # in this row.
  def map_segment_ids(hero)
    comp_player_ids = CompositionPlayer.unscoped.
      where(position: number, composition_id: composition).select(:id)
    composition.player_selections.
      where(hero_id: hero, composition_player_id: comp_player_ids).
      pluck(:map_segment_id)
  end
end
