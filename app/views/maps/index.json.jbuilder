json.maps @maps do |map|
  json.id map.id
  json.name map.name
  json.type map.map_type
  json.segments map.segments do |map_segment|
    json.id map_segment.id
    json.name map_segment.name
  end
  json.compositions @compositions_by_map[map.id] do |composition|
    json.id composition.id
    json.name composition.name
    json.slug composition.slug
  end
end
