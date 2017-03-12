FactoryGirl.define do
  factory :anonymous_user, class: User do
    email "anonymous@overwatch-team-comps.com"
    password "passworD1"
  end

  factory :composition do
    map { Map.first || create(:map) }
    user
  end

  factory :composition_player do
    composition
    player
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
    name { "zion#{Player.count}" }
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

    before(:create) do |player_selection, evaluator|
      create(:composition_player, composition: player_selection.composition,
             player: player_selection.player)
    end
  end

  factory :user do
    email { "jimbob#{User.count}@example.com" }
    password '123abcCatDog!'
    provider 'bnet'
    uid { "123456#{User.count}" }
    battletag { "jimbob#123#{User.count}" }
  end
end
