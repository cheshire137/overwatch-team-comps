import { Router, IndexRoute, Route, browserHistory } from 'react-router'

import AnonLayout from './anon-layout.jsx'
import AuthLayout from './auth-layout.jsx'
import CompositionViewLayout from './composition-view-layout.jsx'

import About from './about.jsx'
import CompositionForm from './composition-form.jsx'
import CompositionView from './composition-view.jsx'
import HeroPoolForm from './hero-pool-form.jsx'
import NotFound from './not-found.jsx'

import LocalStorage from '../models/local-storage'
import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

function storeUserData(json) {
  LocalStorage.set('authenticity-token', json.authenticityToken)
  LocalStorage.set('battletag', json.battletag)
  LocalStorage.set('email', json.email)
  LocalStorage.set('region', json.region)
  LocalStorage.set('platform', json.platform)
}

function clearUserData() {
  LocalStorage.delete('authenticity-token')
  LocalStorage.delete('avatar')
  LocalStorage.delete('battletag')
  LocalStorage.delete('email')
  LocalStorage.delete('region')
  LocalStorage.delete('platform')
}

function requireAuth(nextState, replace, callback) {
  const api = new OverwatchTeamCompsApi()
  api.getUser().then(json => {
    if (json.auth) {
      storeUserData(json)
    } else {
      clearUserData()
      replace({
        pathname: '/',
        state: { nextPathname: nextState.location.pathname }
      })
    }
  }).then(callback)
}

function redirectIfSignedIn(nextState, replace, callback) {
  const newPath = `/user${nextState.location.pathname}`

  if (LocalStorage.has('battletag')) {
    const battletag = LocalStorage.get('battletag')
    if (battletag && battletag.length > 0) {
      replace({
        pathname: newPath,
        state: { nextPathname: nextState.location.pathname }
      })
      callback()
      return
    }
  }

  const api = new OverwatchTeamCompsApi()
  api.getUser().then(json => {
    if (json.auth) {
      storeUserData(json)
      replace({
        pathname: newPath,
        state: { nextPathname: nextState.location.pathname }
      })
    } else {
      clearUserData()
    }
  }).then(callback)
}

const App = function() {
  return (
    <Router history={browserHistory}>
      <Route path="/" component={AnonLayout} onEnter={redirectIfSignedIn}>
        <IndexRoute component={CompositionForm} />
        <Route path="about" component={About} />
      </Route>
      <Route path="/comp" component={CompositionViewLayout}>
        <Route path=":slug" component={CompositionView} />
      </Route>
      <Route path="/user" component={AuthLayout} onEnter={requireAuth}>
        <IndexRoute component={CompositionForm} />
        <Route path="about" component={About} />
        <Route path="hero-pool" component={HeroPoolForm} />
      </Route>
      <Route path="*" component={NotFound} />
    </Router>
  )
}

export default App
