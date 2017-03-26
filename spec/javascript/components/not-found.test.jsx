import renderer from 'react-test-renderer'

import NotFound from '../../../app/assets/javascripts/components/not-found.jsx'

describe('NotFound', () => {
  let component = null

  beforeEach(() => {
    component = <NotFound />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })
})
