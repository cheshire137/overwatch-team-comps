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
  json.players @players do |player|
    if player.persisted?
      json.id player.id
    end
    json.name player.name
    json.heroes @heroes_by_player_name[player.name] do |hero|
      json.id hero.id
      json.name hero.name
      json.confidence @hero_confidences[hero.id][player.name]
      json.mapSegmentID @map_segment_ids[hero.id][player.name]
    end
  end
end
