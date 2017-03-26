function mockLocalStorage(store) {
  window.localStorage = {
    getItem: key => store[key],
    setItem: (key, value) => {
      store[key] = String(value)
    }
  }
}

export default mockLocalStorage
