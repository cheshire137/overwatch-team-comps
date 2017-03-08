import Fetcher from './fetcher'

export default class OverwatchTeamCompsApi extends Fetcher {
  constructor() {
    super('/api')

    const tokenMeta = document.querySelector('meta[name="csrf-token"]')
    this.token = tokenMeta.content
  }

  getMaps() {
    return this.get('/maps').then(json => json.maps)
  }

  getNewComposition() {
    return this.get('/compositions/new').then(json => json.composition)
  }

  savePlayerSelection(body) {
    const headers = {
      'X-CSRF-TOKEN': this.token,
      'Content-type': 'application/json'
    }
    return this.post('/compositions', headers, body).
      then(json => json.composition)
  }
}
