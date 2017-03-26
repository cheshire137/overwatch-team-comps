import renderer from 'react-test-renderer'

import mockLocalStorage from '../mocks/local-storage'

import AuthLayout from '../../../app/assets/javascripts/components/auth-layout.jsx'

describe('AuthLayout', () => {
  let component = null

  beforeEach(() => {
    const store = {
      'overwatch-team-comps': JSON.stringify({ battletag: 'cheetos#1234' })
    }
    mockLocalStorage(store)

    const location = { pathname: '/user' }
    component = (
      <AuthLayout location={location}><p>Hey there</p></AuthLayout>
    )
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })
})
