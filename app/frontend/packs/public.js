import Promise from 'promise-polyfill'

import Vue from 'vue'

import Axios from 'Utils/axios'
Vue.prototype.$http = Axios

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

new Vue({
  el: '#billboard-reservation',
  render: h => h(require('Public/reservation/index.vue').default)
})
