# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

heroes_by_role = {
  support: ['Mercy', 'Zenyatta', 'Ana', 'Lúcio', 'Symmetra'],
  tank: ['D.Va', 'Winston', 'Reinhardt', 'Orisa', 'Roadhog', 'Zarya'],
  offense: ['McCree', 'Pharah', 'Genji', 'Tracer', 'Sombra', 'Soldier: 76', 'Reaper'],
  defense: ['Hanzo', 'Widowmaker', 'Torbjörn', 'Bastion', 'Mei', 'Junkrat']
}

heroes_by_role.each do |role, hero_names|
  puts "Creating #{role} heroes: #{hero_names.to_sentence}"
  hero_names.each do |name|
    Hero.create(name: name, role: role)
  end
end

maps_by_type = {
  assault: ['Hanamura', 'Temple of Anubis', 'Volskaya Industries'],
  escort: ['Dorado', 'Route 66', 'Watchpoint: Gibraltar'],
  hybrid: ['Eichenwalde', 'Hollywood', "King's Row", 'Numbani'],
  control: ['Ilios', 'Lijiang Tower', 'Nepal', 'Oasis'],
  arcade: ['Ecopoint: Antarctica']
}

maps_by_type.each do |type, map_names|
  puts "Creating #{type} maps: #{map_names.to_sentence}"
  map_names.each do |name|
    Map.create(name: name, map_type: type)
  end
end

map_segments_by_map = {
  'Hanamura' => ['First Point', 'Second Point'],
  'Temple of Anubis' => ['First Point', 'Second Point'],
  'Volskaya Industries' => ['First Point', 'Second Point'],
  'Ilios' => ['Well', 'Ruins', 'Lighthouse'],
  'Lijiang Tower' => ['Night Market', 'Control Center', 'Garden'],
  'Nepal' => ['Village', 'Shrine', 'Sanctum'],
  'Oasis' => ['City Center', 'Gardens', 'University'],
  'Hollywood' => ['Capture Point 1', 'Payload 1', 'Payload 2'],
  'Dorado' => ['Payload 1', 'Payload 2', 'Payload 3'],
  "King's Row" => ['Capture Point 1', 'Payload 1', 'Payload 2'],
  'Numbani' => ['Capture Point 1', 'Payload 1', 'Payload 2'],
  'Route 66' => ['Payload 1', 'Payload 2', 'Payload 3'],
  'Watchpoint: Gibraltar' => ['Payload 1', 'Payload 2', 'Payload 3'],
  'Eichenwalde' => ['Capture Point 1', 'Payload 1', 'Payload 2'],
  'Ecopoint: Antarctica' => ['Attack']
}

maps_without_defense = [
  'Ilios', 'Ecopoint: Antarctica', 'Oasis', 'Lijiang Tower', 'Nepal'
]
team_roles = ['Attacking', 'Defending']

map_segments_by_map.each do |map_name, base_segments|
  map = Map.find_by_name(map_name)
  segments = if maps_without_defense.include?(map_name)
    base_segments
  else
    team_roles.inject([]) do |out, role|
      out.concat base_segments.map { |segment| "#{role}: #{segment}" }
    end
  end
  puts "Creating segments for map #{map.name}: #{segments.to_sentence}"
  segments.each do |segment|
    MapSegment.create(map_id: map.id, name: segment)
  end
end

puts "Creating anonymous user"
User.create(
  email: "anonymous@ghost.com",
  password: "passworD1"
)
