import renderer from 'react-test-renderer'

import mockLocalStorage from '../mocks/local-storage'

import Settings from '../../../app/assets/javascripts/components/settings.jsx'

describe('Settings', () => {
  let component = null
  let store = null

  beforeEach(() => {
    store = {
      'overwatch-team-comps': JSON.stringify({
        email: 'user@example.com',
        region: 'eu',
        platform: 'xbl'
      })
    }
    mockLocalStorage(store)

    component = <Settings />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })
})
