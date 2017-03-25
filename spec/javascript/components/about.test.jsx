import renderer from 'react-test-renderer'

import About from '../../../app/assets/javascripts/components/about.jsx'

describe('About', () => {
  let component = null

  beforeEach(() => {
    component = <About />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })
})
