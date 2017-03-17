json.heroPool do
  json.heroes @heroes do |hero|
    json.id hero.id
    json.name hero.name
    json.slug hero.slug
    json.image image_path(hero.image_name)
    json.confidence @confidence_by_hero_id[hero.id] || 0
  end
  json.ranks do
    json.bronze do
      json.confidence 10
      json.image image_path('bronze.png')
    end
    json.silver do
      json.confidence 25
      json.image image_path('silver.png')
    end
    json.gold do
      json.confidence 40
      json.image image_path('gold.png')
    end
    json.platinum do
      json.confidence 55
      json.image image_path('platinum.png')
    end
    json.diamond do
      json.confidence 70
      json.image image_path('diamond.png')
    end
    json.master do
      json.confidence 85
      json.image image_path('master.png')
    end
    json.grandmaster do
      json.confidence 100
      json.image image_path('grandmaster.png')
    end
  end
  json.player do
    json.id @player.id
    json.name @player.name
  end
  json.user do
    json.battletag @user.battletag
  end
end
