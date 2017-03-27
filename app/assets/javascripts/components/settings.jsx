import LocalStorage from '../models/local-storage'
import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

class Settings extends React.Component {
  constructor() {
    super()
    this.state = {
      platform: LocalStorage.get('platform'),
      region: LocalStorage.get('region'),
      email: LocalStorage.get('email'),
      isRequestOut: false
    }
  }

  onEmailChange(event) {
    this.setState({ email: event.target.value })
  }

  onPlatformChange(event) {
    this.setState({ platform: event.target.value })
  }

  onRegionChange(event) {
    this.setState({ region: event.target.value })
  }

  onUserUpdated(user) {
    LocalStorage.set('platform', user.platform)
    LocalStorage.set('region', user.region)

    // Wipe avatar so it is fetched anew based on the updated platform,
    // region next time the page loads
    LocalStorage.delete('avatar')

    this.setState({
      platform: user.platform,
      region: user.region,
      isRequestOut: false
    })
  }

  onUserUpdateError(error) {
    console.error('failed to update settings', error)
    this.setState({ isRequestOut: false })
  }

  save(event) {
    event.preventDefault()

    const { email, platform, region } = this.state
    const api = new OverwatchTeamCompsApi()
    const body = { email, platform, region }

    this.setState({ isRequestOut: true }, () => {
      api.updateUser(body).
        then(user => this.onUserUpdated(user)).
        catch(err => this.onUserUpdateError(err))
    })
  }

  render() {
    const { email, platform, region, isRequestOut } = this.state

    return (
      <div className="container">
        <form
          onSubmit={e => this.save(e)}
          className="settings-form"
        >
          <div className="field">
            <label
              htmlFor="email"
              className="label"
            >Email address:</label>
            <input
              id="email"
              type="text"
              className="input"
              value={email}
              disabled={isRequestOut}
              onChange={e => this.onEmailChange(e)}
              placeholder="Your email address"
            />
          </div>
          <div className="field">
            <label
              htmlFor="platform"
              className="label"
            >Which platform do you primarily play on?</label>
            <div>
              <span
                className={`select ${isRequestOut ? 'is-disabled' : ''}`}
              >
                <select
                  name="platform"
                  id="platform"
                  value={platform}
                  disabled={isRequestOut}
                  onChange={e => this.onPlatformChange(e)}
                >
                  <option value="pc">PC</option>
                  <option value="psn">PlayStation</option>
                  <option value="xbl">Xbox</option>
                </select>
              </span>
            </div>
          </div>
          <div className="field">
            <label
              htmlFor="region"
              className="label"
            >Which region do you primarily play in?</label>
            <div>
              <span
                className={`select ${isRequestOut ? 'is-disabled' : ''}`}
              >
                <select
                  name="region"
                  id="region"
                  value={region}
                  disabled={isRequestOut}
                  onChange={e => this.onRegionChange(e)}
                >
                  <option value="us">United States</option>
                  <option value="eu">Europe</option>
                  <option value="kr">South Korea</option>
                  <option value="cn">China</option>
                  <option value="global">Global</option>
                </select>
              </span>
            </div>
          </div>
          <button
            type="submit"
            disabled={isRequestOut}
            className="button is-primary"
          >Save</button>
        </form>
      </div>
    )
  }
}

export default Settings
