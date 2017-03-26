import Fetcher from './fetcher'

export default class OverwatchTeamCompsApi extends Fetcher {
  constructor() {
    super('/api')

    const tokenMeta = document.querySelector('meta[name="csrf-token"]')
    this.token = tokenMeta.content

    this.defaultHeaders = {
      'X-CSRF-TOKEN': this.token,
      'Content-type': 'application/json'
    }
  }

  getUser() {
    return this.get('/user', this.defaultHeaders)
  }

  getMaps() {
    return this.get('/maps', this.defaultHeaders).then(json => json.maps)
  }

  getHeroPool() {
    return this.get('/heroes/pool', this.defaultHeaders).
      then(json => json.heroPool)
  }

  saveHeroPool(body) {
    return this.post('/heroes/pool', this.defaultHeaders, body).
      then(json => json.heroPool)
  }

  getLastComposition(mapID) {
    let path = '/composition/last'
    if (typeof mapID !== 'undefined') {
      path = `${path}?map_id=${mapID}`
    }
    return this.get(path, this.defaultHeaders).
      then(json => json.composition)
  }

  getComposition(slug) {
    return this.get(`/composition/${slug}`, this.defaultHeaders).
      then(json => json.composition)
  }

  saveComposition(body) {
    return this.post('/compositions', this.defaultHeaders, body).
      then(json => json.composition)
  }

  createPlayer(body) {
    return this.post('/players', this.defaultHeaders, body).
      then(json => json.composition)
  }

  updatePlayer(id, body) {
    return this.put(`/players/${id}`, this.defaultHeaders, body).
      then(json => json.composition)
  }

  deletePlayer(id, body) {
    return this.delete(`/players/${id}`, this.defaultHeaders, body).
      then(json => json.composition)
  }
}
