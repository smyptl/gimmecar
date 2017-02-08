import Promise from 'promise-polyfill'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

import Vue from 'vue'

import Axios from 'Utils/axios'
Vue.prototype.$http = Axios

import InputError from 'Components/inputs/error'
Vue.directive('error', InputError)

import InputErrorMessage from 'Components/inputs/error_message'
Vue.component('input-error-message', InputErrorMessage)

var vue = new Vue({
  render: h => h(require('./base')),
}).$mount('#gimmecar-app')
