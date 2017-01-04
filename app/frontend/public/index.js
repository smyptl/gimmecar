import Promise from 'promise-polyfill'

import Vue from 'vue'
import Reservation from './reservation/_index.vue'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

new Vue({
  el: '#billboard-reservation',
  render: h => h(Reservation)
})
