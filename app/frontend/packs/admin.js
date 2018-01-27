import Promise from 'promise-polyfill'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import Axios from 'Utils/axios'
Vue.prototype.$http = Axios

import InputError from 'Components/inputs/error'
Vue.directive('error', InputError)

import InputErrorMessage from 'Components/inputs/error_message'
Vue.component('input-error-message', InputErrorMessage)

const router = new VueRouter(require('Admin/routes.js'))

var vue = new Vue({
  router,
  render: h => h(require('Admin/base')),
}).$mount('#gimmecar-app')
