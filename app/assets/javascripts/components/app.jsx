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

function requireAuth(nextState, replace, callback) {
  const api = new OverwatchTeamCompsApi()
  api.getUser().then(json => {
    if (json.auth) {
      LocalStorage.set('battletag', json.battletag)
    } else {
      LocalStorage.delete('battletag')
      replace({
        pathname: '/',
        state: { nextPathname: nextState.location.pathname }
      })
    }
  }).then(callback)
}

function redirectIfSignedIn(nextState, replace, callback) {
  if (LocalStorage.has('battletag')) {
    const battletag = LocalStorage.get('battletag')
    if (battletag && battletag.length > 0) {
      replace({
        pathname: `/user${nextState.location.pathname}`,
        state: { nextPathname: nextState.location.pathname }
      })
      callback()
      return
    }
  }

  const api = new OverwatchTeamCompsApi()
  api.getUser().then(json => {
    if (json.auth) {
      LocalStorage.set('battletag', json.battletag)
      replace({
        pathname: '/user',
        state: { nextPathname: nextState.location.pathname }
      })
    } else {
      LocalStorage.delete('battletag')
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
