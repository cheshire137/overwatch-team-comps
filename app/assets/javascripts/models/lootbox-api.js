import Fetcher from './fetcher'

// See https://api.lootbox.eu/documentation
export default class LootboxApi extends Fetcher {
  constructor(platform, region) {
    super('https://api.lootbox.eu/')
    this.platform = platform
    this.region = region
  }

  getProfile(battletag) {
    const parts = battletag.split('#')
    const path = `/${this.platform}/${this.region}/${parts[0]}-${parts[1]}/profile`
    return this.get(path).then(json => json.data)
  }
}
