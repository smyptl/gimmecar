import Promise from 'promise-polyfill'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

var Layout = require('./layout')
var Application = require('./base')

const router = new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', name: 'dashboard', component: Application },
  ],
})

new Vue({
  router,
  render: h => h(Layout),
}).$mount('#gimmecar-app')
