import renderer from 'react-test-renderer'

import Settings from '../../../app/assets/javascripts/components/settings.jsx'

describe('Settings', () => {
  let component = null

  beforeEach(() => {
    component = <Settings />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })
})
