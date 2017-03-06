FactoryGirl.define do
  factory :map do
    name "Dorado"
    map_type "escort"
  end

  factory :map_segment do
    map
    name "Attacking: Payload 1"
  end
end
