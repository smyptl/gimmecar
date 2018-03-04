import Promise from 'promise-polyfill'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

import Vue from 'vue'

import Axios from 'Utils/axios'
Vue.prototype.$http = Axios

var vue = new Vue({
  render: h => h(require('Admin/location/rentals/rental/receipt.vue')),
}).$mount('#gimmecar-app')
