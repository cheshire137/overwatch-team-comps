import renderer from 'react-test-renderer'
import { shallow } from 'enzyme'

import PlayerSelect from '../../../app/assets/javascripts/components/player-select.jsx'

describe('PlayerSelect', () => {
  let component = null
  const player1 = { id: 1, name: 'Sally' }
  const player2 = { id: 2, name: 'Jimmy' }
  let selectedPlayerID = player1.id
  let wasEditPlayerCalled = false
  let savedName = null
  const props = {
    inputID: 'input-dom-id',
    playerID: selectedPlayerID,
    players: [player1, player2],
    onChange: (newPlayerID, newName) => {
      selectedPlayerID = newPlayerID
      savedName = newName
    },
    label: 'Player 1 selection',
    editPlayer: () => { wasEditPlayerCalled = true },
    disabled: false
  }

  beforeEach(() => {
    component = <PlayerSelect {...props} />
  })

  test('matches snapshot', () => {
    const tree = renderer.create(component).toJSON()
    expect(tree).toMatchSnapshot()
  })

  test('can change selected player', () => {
    const select = shallow(component).find('select')
    select.simulate('change', { target: { value: player2.id } })
    expect(selectedPlayerID).toBe(player2.id)
  })

  test('can show new player text field', () => {
    const rendered = shallow(component)

    expect(rendered.find(`#${props.inputID}`).length).toBe(0)

    const select = rendered.find('select')
    select.simulate('change', { target: { value: 'new' } })

    expect(rendered.find(`#${props.inputID}`).length).toBe(1)
  })

  test('can create new player', () => {
    const rendered = shallow(component)

    const select = rendered.find('select')
    select.simulate('change', { target: { value: 'new' } })

    const nameField = rendered.find(`#${props.inputID}`)
    nameField.simulate('change', { target: { value: 'Terry  ' } })

    const saveButton = rendered.find('.save-new-name-button')
    expect(saveButton.length).toBe(1)

    saveButton.simulate('click', { preventDefault: () => {} })
    expect(savedName).toBe('Terry')
  })

  test('can open modal to edit player', () => {
    const rendered = shallow(component)

    const button = rendered.find('.edit-player-button')
    expect(button.length).toBe(1)

    button.simulate('click', { currentTarget: { blur: () => {} } })

    expect(wasEditPlayerCalled).toBe(true)
  })
})
