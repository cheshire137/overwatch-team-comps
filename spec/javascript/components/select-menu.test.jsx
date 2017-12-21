import renderer from 'react-test-renderer'
import { shallow } from 'enzyme'

import SelectMenu from '../../../app/assets/javascripts/components/select-menu.jsx'

describe('SelectMenu', () => {
  let component = null
  const item1 = { id: 1, name: 'First item' }
  let idSelected = item1.id
  const item2 = { id: 2, name: 'Second item' }
  const props = {
    items: [item1, item2],
    onChange: newID => { idSelected = newID },
    selectedItemID: idSelected,
    disabled: false,
    menuClass: () => 'custom-menu-class',
    containerClass: () => 'custom-container-class',
    menuToggleContents: () => <span>Menu</span>,
    menuItemClass: item => `item-${item.id}`,
    menuItemContent: (item, isSelected) => (
      <span className={isSelected ? 'with-selected' : ''}>
        <span className="css-truncate">{item.name}</span>
      </span>
    )
  }

  beforeEach(() => {
    component = <SelectMenu {...props} />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })

  test('can change selected item', () => {
    const rendered = shallow(component)

    const select = rendered.find('.menu-toggle')
    select.simulate('click', { target: { blur: () => {} } })

    const menuItemButton = rendered.find('.menu-item.item-2')
    menuItemButton.simulate('click', {
      preventDefault: () => {},
      target: { blur: () => {} }
    })

    expect(idSelected).toBe(item2.id)
  })
})
