// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts,
// vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_self
//= require react
//= require react_ujs

/* eslint-disable global-require */

const isProduction = window.location.host.indexOf('herokuapp.com') > -1
const isHttps = window.location.protocol === 'https:'
if (isProduction && !isHttps) {
  window.location.href = `https:${window.location.href.substring(window.location.protocol.length)}`
} else {
  window.React = global.React = require('react')

  const Promise = require('promise-polyfill')

  if (!window.Promise) {
    window.Promise = Promise
  }

  require('whatwg-fetch')
  require('./components')
}

