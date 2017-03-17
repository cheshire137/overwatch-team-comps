json.heroPool do
  json.heroes @heroes do |hero|
    json.id hero.id
    json.name hero.name
    json.image image_path(hero.image_name)
    json.confidence @confidence_by_hero_id[hero.id] || 0
  end
  json.player do
    json.id @player.id
    json.name @player.name
  end
  json.user do
    json.battletag @user.battletag
  end
end
