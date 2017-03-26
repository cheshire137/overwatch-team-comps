import fetchMock from 'fetch-mock'
import React from 'react'

// Ensure we're not talking to any external service by making all
// unmocked requests return a 503 response code.
//
// http://www.wheresrhys.co.uk/fetch-mock/api
fetchMock.catch(503)

global.React = React
