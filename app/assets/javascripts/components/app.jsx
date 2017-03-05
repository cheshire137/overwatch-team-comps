import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

export default class App extends React.Component {
  static onMapsError(error) {
    console.error('failed to load maps', error)
  }

  constructor() {
    super()
    this.state = { maps: [] }
  }

  componentDidMount() {
    const api = new OverwatchTeamCompsApi()
    api.getMaps().then(maps => this.onMapsFetched(maps)).
      catch(err => App.onMapsError(err))
  }

  onMapsFetched(maps) {
    this.setState({ maps })
  }

  render() {
    const { maps } = this.state
    if (maps.length < 1) {
      return <p>hello world</p>
    }
    return (
      <ul>{
        maps.map(map => <li key={map.name}>{map.name}</li>)
      }</ul>
    )
  }
}
