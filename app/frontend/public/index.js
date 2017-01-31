import Promise from 'promise-polyfill'

import Vue from 'vue'

import Axios from 'Utils/axios'
Vue.prototype.$http = Axios

import Reservation from './reservation/index.vue'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

new Vue({
  el: '#billboard-reservation',
  render: h => h(Reservation)
})
