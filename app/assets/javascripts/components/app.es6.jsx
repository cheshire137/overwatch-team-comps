class App extends React.Component {
  constructor() {
    super()
    this.state = { maps: [] }
  }

  componentDidMount() {
    const api = new OverwatchTeamCompsApi()
    api.getMaps().then(maps => this.onMapsFetched(maps)).
      catch(err => this.onMapsError(err))
  }

  onMapsFetched(maps) {
    this.setState({ maps })
  }

  onMapsError(error) {
    console.error('failed to load maps', error)
  }

  render () {
    const { maps } = this.state
    if (maps.length < 1) {
      return <p>hello world</p>
    }
    return (
      <ul>{
        maps.map(map => {
          return <li key={map.name}>{map.name}</li>
        })
      }</ul>
    )
  }
}
