require('whatwg-fetch')

class Fetcher {
  constructor(basePath) {
    this.basePath = basePath
  }

  checkStatus(response) {
    if (response.status >= 200 && response.status < 300) {
      return response
    }
    const error = new Error(response.statusText)
    error.response = response
    throw error
  }

  parseJson(response) {
    return response.json()
  }

  get(path, headers) {
    return this.makeRequest('GET', path, headers)
  }

  makeRequest(method, path, headers, body) {
    const url = `${this.basePath}${path}`
    const data = { method, headers }
    if (body) {
      data.body = JSON.stringify(body)
    }
    return fetch(url, data).then(this.checkStatus).
      then(this.parseJson)
  }
}

window.Fetcher = Fetcher
