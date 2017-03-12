json.composition do
  if @composition.persisted?
    json.id @composition.id
  end
  json.name @composition.name
  json.notes @composition.notes
  json.map do
    json.id @composition.map.id
    json.name @composition.map.name
    json.type @composition.map.map_type
    json.segments @composition.map.segments do |map_segment|
      json.id map_segment.id
      json.name map_segment.name
    end
  end
  json.availablePlayers @available_players do |player|
    json.id player.id
    json.name player.name
  end
  json.players @rows do |row|
    json.id row.player.id
    json.name row.player.name
    json.heroes row.heroes do |hero|
      json.id hero.id
      json.name hero.name
      json.confidence row.hero_confidence(hero)
      json.mapSegmentIDs row.map_segment_ids(hero)
    end
  end
end
