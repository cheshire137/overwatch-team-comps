import renderer from 'react-test-renderer'

import AnonLayout from '../../../app/assets/javascripts/components/anon-layout.jsx'

describe('AnonLayout', () => {
  let component = null

  beforeEach(() => {
    const location = { pathname: '/about' }
    component = (
      <AnonLayout location={location}><p>Hey there</p></AnonLayout>
    )
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })
})
