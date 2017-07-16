import renderer from 'react-test-renderer'

import MapSelect from '../../../app/assets/javascripts/components/map-select.jsx'

describe('MapSelect', () => {
  let component = null
  const map1 = {
    id: 4,
    slug: 'dorado',
    name: 'Dorado',
    type: 'escort',
    segments: [{ id: 31, name: 'Attack: Payload 1' }],
    compositions: []
  }
  let mapIDSelected = map1.id
  const map2 = {
    id: 7,
    slug: 'eichenwalde',
    name: 'Eichenwalde',
    type: 'hybrid',
    segments: [{ id: 61, name: 'Attack: Point 1' }],
    compositions: []
  }
  const props = {
    maps: [map1, map2],
    onChange: newMapID => { mapIDSelected = newMapID },
    selectedMapID: mapIDSelected,
    disabled: false
  }

  beforeEach(() => {
    component = <MapSelect {...props} />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })
})
