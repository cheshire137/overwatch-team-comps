require 'rails_helper'

describe MapSegment do
  it 'requires a name' do
    map_segment = MapSegment.new
    expect(map_segment.valid?).to be_falsey
    expect(map_segment.errors[:name].any?).to be_truthy
  end

  it 'requires a map' do
    map_segment = MapSegment.new
    expect(map_segment.valid?).to be_falsey
    expect(map_segment.errors[:map].any?).to be_truthy
  end

  it 'requires a unique map + name combination' do
    map = Map.create!(name: 'Route 66')
    map_segment1 = MapSegment.create!(name: 'Payload 1', map: map)

    map_segment2 = MapSegment.new(name: map_segment1.name,
                                  map: map_segment1.map)
    expect(map_segment2.valid?).to be_falsey
    expect(map_segment2.errors[:map_id].any?).to be_truthy
  end
end
