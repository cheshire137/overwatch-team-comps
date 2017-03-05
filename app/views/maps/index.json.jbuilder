json.maps @maps do |map|
  json.name map.name
  json.type map.map_type
  json.segments map.segments do |map_segment|
    json.name map_segment.name
  end
end
