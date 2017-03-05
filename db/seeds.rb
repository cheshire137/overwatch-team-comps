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
  offense: ['McCree', 'Pharah', 'Genji', 'Tracer', 'Sombra', 'Soldier 76', 'Reaper'],
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
  control: ['Ilios: Lighthouse', 'Ilios: Well', 'Ilios: Ruins',
            'Lijiang Tower: Night Market', 'Lijiang Tower: Garden',
            'Lijiang Tower: Control Center',
            'Nepal: Village', 'Nepal: Shrine', 'Nepal: Sanctum',
            'Oasis: City Center', 'Oasis: Gardens', 'Oasis: University'],
  arcade: ['Ecopoint: Antarctica']
}

maps_by_type.each do |type, map_names|
  puts "Creating #{type} maps: #{map_names.to_sentence}"
  map_names.each do |name|
    Map.create(name: name, map_type: type)
  end
end
