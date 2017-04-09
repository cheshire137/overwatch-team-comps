json.composition do
  if @composition.persisted?
    json.id @composition.id
    json.updatedAt @composition.updated_at.iso8601
  end
  json.user do
    json.battletag @composition.user.try(:battletag)
  end
  json.slug @composition.slug
  json.name @composition.name
  json.notes @composition.notes
  json.map do
    json.id @composition.map.id
    json.name @composition.map.name
    json.slug @composition.map.slug
    if image_exists?(@composition.map.image_name)
      json.image image_path(@composition.map.image_name)
    end
    json.type @composition.map.map_type
    json.segments @composition.map.segments do |map_segment|
      json.id map_segment.id
      json.name map_segment.name
      json.filled @builder.map_segment_filled?(map_segment)
      json.isAttack map_segment.is_attack?
      json.isFirstOfKind @builder.map_segment_is_first_of_kind?(map_segment)
      json.isLastOfKind @builder.map_segment_is_last_of_kind?(map_segment)
    end
  end
  json.availablePlayers @available_players do |player|
    json.id player.id
    json.name player.name
    json.battletag player.battletag
  end
  json.players @builder.rows do |row|
    if row.player
      json.id row.player.id
      json.name row.player.name
      json.battletag row.player.battletag
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
          json.image image_path(hero.image_name)
        end
      end
    end
  end

  if @builder.any_duplicates?
    # Hash of player ID => map segment ID => Boolean
    json.duplicatePicks do
      @builder.rows.each do |row|
        if row.player
          json.set! row.player.id do
            @builder.map_segments.each do |map_segment|
              json.set! map_segment.id, row.duplicate?(map_segment)
            end
          end
        end
      end
    end
  else
    json.duplicatePicks Hash.new
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
