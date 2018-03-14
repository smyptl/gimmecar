import Promise from 'promise-polyfill'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

import Vue from 'vue'

import Axios from 'Utils/axios'
Vue.prototype.$http = Axios

import Receipt from 'Admin/location/rentals/rental/receipt.vue'

var vue = new Vue({
  render: h => h(Receipt),
}).$mount('#gimmecar-app')
