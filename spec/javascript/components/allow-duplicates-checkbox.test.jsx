import renderer from 'react-test-renderer'
import { shallow } from 'enzyme'

import AllowDuplicatesCheckbox from '../../../app/assets/javascripts/components/allow-duplicates-checkbox.jsx'

describe('AllowDuplicatesCheckbox', () => {
  let component = null
  let isAllowed = false

  const props = {
    checked: isAllowed,
    onChange: allowed => { isAllowed = allowed }
  }

  beforeEach(() => {
    component = <AllowDuplicatesCheckbox {...props} />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })

  test('notices when checkbox is toggled', () => {
    const checkbox = shallow(component).find('#allow-duplicates')
    checkbox.simulate('change', { target: { checked: true } })
    expect(isAllowed).toBe(true)
  })
})
