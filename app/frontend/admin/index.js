import Promise from 'promise-polyfill'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

var Layout = require('./layout')
var Dashboard = require('./dashboard/base')
var Reservations = require('./reservations/base')

const router = new VueRouter({
  linkActiveClass: 'active',
  routes: [
    { path: '/dashboard', name: 'dashboard', component: Dashboard },
    { path: '/reservations', name: 'reservations', component: Reservations },
  ],
})

new Vue({
  router,
  render: h => h(Layout),
}).$mount('#gimmecar-app')
