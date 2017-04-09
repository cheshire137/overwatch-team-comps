import renderer from 'react-test-renderer'

import PlayerSelect from '../../../app/assets/javascripts/components/player-select.jsx'

describe('PlayerSelect', () => {
  let component = null
  const player1 = { id: 1, name: 'Sally' }
  const player2 = { id: 2, name: 'Jimmy' }
  let selectedPlayerID = player1.id
  let wasEditPlayerCalled = false
  const props = {
    inputID: 'input-dom-id',
    playerID: selectedPlayerID,
    players: [player1, player2],
    onChange: newPlayerID => { selectedPlayerID = newPlayerID },
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
})
