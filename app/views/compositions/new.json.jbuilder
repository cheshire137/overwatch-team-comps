json.composition do
  json.name @composition.name
  json.notes @composition.notes
  json.map do
    json.id @composition.map.id
    json.name @composition.map.name
    json.type @composition.map.map_type
    json.segments @composition.map.segments.pluck(:name)
  end
  json.players @players do |player|
    json.name player.name
    json.heroes player.player_heroes do |player_hero|
      json.id player_hero.hero.id
      json.name player_hero.hero.name
      json.confidence player_hero.confidence
    end
  end
end
