class OverwatchTeamCompsApi extends Fetcher {
  constructor() {
    super('/api')
  }

  getMaps() {
    return this.get('/maps').then(json => json.maps)
  }
}

window.OverwatchTeamCompsApi = OverwatchTeamCompsApi
