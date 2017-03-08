json.composition do
  json.name @composition.name
  json.notes @composition.notes
  json.map do
    json.name @composition.map.name
    json.type @composition.map.map_type
    json.segments @composition.map.segments.pluck(:name)
  end
  json.players @players do |player|
    json.name player.name
  end
end
