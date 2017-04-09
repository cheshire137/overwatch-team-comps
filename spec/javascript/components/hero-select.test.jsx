import renderer from 'react-test-renderer'

import HeroSelect from '../../../app/assets/javascripts/components/hero-select.jsx'

describe('HeroSelect', () => {
  let component = null
  let heroIDSelected = null

  beforeEach(() => {
    const hero1 = { id: 1, image: '/photo.jpg', name: 'Hanzo' }
    const hero2 = { id: 2, image: '/pic.bmp', name: 'Ana' }
    const props = {
      heroes: [hero1, hero2],
      onChange: newHeroID => { heroIDSelected = newHeroID },
      selectedHeroID: 1,
      disabled: false,
      selectID: 'hero-select-dom-id',
      isDuplicate: false
    }
    component = <HeroSelect {...props} />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })
})
