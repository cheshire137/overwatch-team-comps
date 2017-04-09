require 'rails_helper'

RSpec.describe CompositionRow, type: :model do
  before(:each) do
    @map = create(:map)
    @composition = create(:composition, map: @map)
    @player = create(:player, creator: @composition.user)
    @comp_player = create(:composition_player, player: @player,
                          composition: @composition)
    @hero1 = create(:hero, name: 'McCree')
    @hero2 = create(:hero, name: 'Widowmaker')
    @map_segment = create(:map_segment, map: @map)
  end

  describe '#duplicate?' do
    it 'returns true when a duplicate exists for given segment' do
      # Player selection for this player:
      create(:player_selection, composition_player: @comp_player,
             map_segment: @map_segment, hero: @hero1)

      # Player selection for another player:
      create(:player_selection, map_segment: @map_segment, hero: @hero1)

      heroes_by_segment = { @map_segment.id => [@hero1.id, @hero1.id] }

      player_selections = @composition.player_selections.
        select(:map_segment_id, :position, :player_id, :hero_id).to_a

      row = CompositionRow.new(number: 0, player: @player,
                               all_heroes: [@hero1, @hero2],
                               player_selections: player_selections,
                               heroes_by_segment: heroes_by_segment)

      expect(row.duplicate?(@map_segment)).to eq(true)
    end

    it 'returns false when no hero is selected for that segment and player' do
      # Player selection for another player:
      create(:player_selection, map_segment: @map_segment, hero: @hero1)

      heroes_by_segment = { @map_segment.id => [@hero1.id] }

      player_selections = @composition.player_selections.
        select(:map_segment_id, :position, :player_id, :hero_id).to_a

      row = CompositionRow.new(number: 0, player: @player,
                               all_heroes: [@hero1, @hero2],
                               player_selections: player_selections,
                               heroes_by_segment: heroes_by_segment)

      expect(row.duplicate?(@map_segment)).to eq(false)
    end

    it 'returns false when no duplicate exists for that segment' do
      # Player selection for this player:
      create(:player_selection, composition_player: @comp_player,
             map_segment: @map_segment, hero: @hero1)

      # Player selection for another player:
      create(:player_selection, map_segment: @map_segment, hero: @hero2)

      heroes_by_segment = { @map_segment.id => [@hero1.id, @hero2.id] }

      player_selections = @composition.player_selections.
        select(:map_segment_id, :position, :player_id, :hero_id).to_a

      row = CompositionRow.new(number: 0, player: @player,
                               all_heroes: [@hero1, @hero2],
                               player_selections: player_selections,
                               heroes_by_segment: heroes_by_segment)

      expect(row.duplicate?(@map_segment)).to eq(false)
    end
  end
end
