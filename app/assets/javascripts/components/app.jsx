import { Router, IndexRoute, Route, browserHistory } from 'react-router'

import AnonLayout from './anon-layout.jsx'
import AuthLayout from './auth-layout.jsx'
import CompositionForm from './composition-form.jsx'
import HeroPoolForm from './hero-pool-form.jsx'
import NotFound from './not-found.jsx'

import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

function requireAuth(nextState, replace, callback) {
  const api = new OverwatchTeamCompsApi()
  api.getUser().then(json => {
    if (!json.auth) {
      replace({
        pathname: '/',
        state: { nextPathname: nextState.location.pathname }
      })
    }
  }).then(callback)
}

function redirectIfSignedIn(nextState, replace, callback) {
  const api = new OverwatchTeamCompsApi()
  api.getUser().then(json => {
    if (json.auth) {
      replace({
        pathname: '/user',
        state: { nextPathname: nextState.location.pathname }
      })
    }
  }).then(callback)
}

const App = function() {
  return (
    <Router history={browserHistory}>
      <Route path="/" component={AnonLayout}>
        <IndexRoute component={CompositionForm} onEnter={redirectIfSignedIn} />
      </Route>
      <Route path="/user" component={AuthLayout} onEnter={requireAuth}>
        <IndexRoute component={CompositionForm} />
        <Route path="hero-pool" component={HeroPoolForm} />
      </Route>
      <Route path="*" component={NotFound} />
    </Router>
  )
}

export default App
