import Promise from 'promise-polyfill'

import Vue from 'vue'

import Axios from 'axios'
Axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
Axios.defaults.headers.common['X-CSRF-Token'] = document.getElementsByName('csrf-token')[0].content
Vue.prototype.$http = Axios

import Reservation from './reservation/_index.vue'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

new Vue({
  el: '#billboard-reservation',
  render: h => h(Reservation)
})
