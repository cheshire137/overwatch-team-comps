import { Router, IndexRoute, Route, browserHistory } from 'react-router'

import AnonLayout from './anon-layout.jsx'
import CompositionForm from './composition-form.jsx'
import NotFound from './not-found.jsx'

const App = function() {
  return (
    <Router history={browserHistory}>
      <Route path="/" component={AnonLayout}>
        <IndexRoute component={CompositionForm} />
      </Route>
      <Route path="*" component={NotFound} />
    </Router>
  )
}

export default App
