import fetchMock from 'fetch-mock'
import renderer from 'react-test-renderer'
import { shallow } from 'enzyme'

import mockLocalStorage from '../mocks/local-storage'
import waitForRequests from '../helpers/wait-for-requests'

import AuthLayout from '../../../app/assets/javascripts/components/auth-layout.jsx'

describe('AuthLayout', () => {
  let component = null
  let store = null
  let profileReq = null

  beforeEach(() => {
    store = {
      'overwatch-team-comps': JSON.stringify({
        battletag: 'cheetos#1234',
        region: 'kr',
        platform: 'psn'
      })
    }
    mockLocalStorage(store)

    const lootboxResponse = {
      data: { avatar: 'http://example.com/image.png' }
    }
    profileReq = fetchMock.get('https://api.lootbox.eu/psn/kr/cheetos-1234/profile',
                               lootboxResponse)

    const location = { pathname: '/user' }
    component = (
      <AuthLayout location={location}><p>Hey there</p></AuthLayout>
    )
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })

  test('saves avatar in local storage', done => {
    const expected = JSON.stringify({
      battletag: 'cheetos#1234',
      region: 'kr',
      platform: 'psn',
      avatar: 'http://example.com/image.png'
    })

    shallow(component)

    waitForRequests([profileReq], done, done.fail, () => {
      expect(store['overwatch-team-comps']).toEqual(expected)
    })
  })
})
