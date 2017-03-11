FactoryGirl.define do
  factory :anonymous_user, class: User do
    email "anonymous@overwatch-team-comps.com"
    password "passworD1"
  end

  factory :composition do
    map { Map.first || create(:map) }
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
    association :creator, factory: :user
  end

  factory :player_hero do
    player
    hero
    confidence 60
  end

  factory :player_selection do
    player
    hero
    composition
    map_segment { create(:map_segment, map: composition.map) }
  end

  factory :user do
    email { "jimbob#{User.count}@example.com" }
    password '123abcCatDog!'
    provider 'bnet'
    uid { "123456#{User.count}" }
    battletag { "jimbob#123#{User.count}" }
  end
end
