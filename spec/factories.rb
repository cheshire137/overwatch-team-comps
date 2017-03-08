FactoryGirl.define do
  factory :anonymous_user, class: User do
    email "anonymous@ghost.com"
    password "passworD1"
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
end
