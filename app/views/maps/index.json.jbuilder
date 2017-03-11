json.maps @maps do |map|
  json.id map.id
  json.name map.name
  json.type map.map_type
  json.segments map.segments do |map_segment|
    json.id map_segment.id
    json.name map_segment.name
  end
end
