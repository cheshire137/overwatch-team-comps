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
  json.players @builder.rows do |row|
    if row.player
      json.id row.player.id
      json.name row.player.name
    else
      json.name ''
    end
  end

  # Hash of player ID => heroes
  json.heroes do
    @builder.rows.each do |row|
      if row.player
        json.set! row.player.id, row.heroes do |hero|
          json.id hero.id
          json.slug hero.slug
          json.name hero.name
        end
      end
    end
  end

  # Hash of player ID => map segment ID => hero ID
  json.selections do
    @builder.rows.each do |row|
      if row.player
        json.set! row.player.id do
          @builder.map_segments.each do |map_segment|
            json.set! map_segment.id, row.selected_hero(map_segment)
          end
        end
      end
    end
  end
end
