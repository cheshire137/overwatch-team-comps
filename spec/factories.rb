FactoryGirl.define do
  factory :anonymous_user, class: User do
    email { User::ANONYMOUS_EMAIL }
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

  factory :default_player, class: Player do
    name { Player::DEFAULT_NAME }
    creator { User.anonymous || create(:anonymous_user) }
  end

  factory :hero do
    name 'McCree'
    role 'offense'
  end

  factory :map do
    name { "Dorado #{Map.count}" }
    map_type 'escort'
  end

  factory :map_segment do
    map
    name { "Attacking: Payload #{MapSegment.count}" }
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
    hero
    composition_player
    map_segment { create(:map_segment, map: composition_player.composition.map) }
  end

  factory :user do
    email { "jimbob#{User.count}@example.com" }
    password '123abcCatDog!'
    provider 'bnet'
    uid { "123456#{User.count}" }
    battletag { "jimbob#123#{User.count}" }
  end
end
