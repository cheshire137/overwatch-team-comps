json.composition do
  json.id @composition.id
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

  # Six players, one per row in composition form:
  json.players @players do |player|
    if player.persisted? && !player.default?
      json.id player.id
    end
    json.name player.name
    json.heroes @heroes_by_player[player.id] do |hero|
      json.id hero.id
      json.name hero.name
      json.confidence @hero_confidences[player.id][hero.id]
      json.mapSegmentIDs @map_segment_ids[player.id][hero.id]
    end
  end
end
