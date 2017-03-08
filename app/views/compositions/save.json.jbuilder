json.composition do
  json.id @composition.id
  json.name @composition.name
  json.notes @composition.notes
  json.map do
    json.name @map.name
    json.type @map.map_type
    json.segments @map.segments.pluck(:name)
  end
  json.players @players do |player|
    json.name player.name
    json.selectedHero do
      json.name @player_selection.player_hero.hero.name
    end
    json.heroes player.player_heroes do |player_hero|
      json.name player_hero.hero.name
      json.confidence player_hero.confidence
    end
  end
end
