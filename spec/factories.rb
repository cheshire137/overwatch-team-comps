FactoryGirl.define do
  factory :composition do
    name 'Best Ever Dive Comp'
    map
    user
  end

  factory :hero do
    name 'McCree'
    role 'offense'
  end

  factory :map do
    name 'Dorado'
    map_type 'escort'
  end

  factory :map_segment do
    map
    name 'Attacking: Payload 1'
  end

  factory :player do
    name 'zion'
  end

  factory :player_hero do
    player
    hero
    confidence 60
  end

  factory :player_selection do
    player_hero
    composition
  end

  factory :user do
    email 'jimbob@example.com'
    password '123abcCatDog!'
    provider 'bnet'
    uid '123456'
    battletag 'jimbob#1234'
  end
end
