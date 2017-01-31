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

const router = new VueRouter({
  mode: 'history',
  linkActiveClass: 'active',
  routes: [
    { path: '/:location/dashboard',    name: 'dashboard',    component: require('./dashboard/base') },
    { path: '/:location/reservations', name: 'reservations', component: require('./reservations/base') },
    { path: '/:location/rentals',      name: 'rentals',      component: require('./rentals/base') },
    { path: '/:location/rates',        name: 'rates',        component: require('./rates/base') },
    { path: '/:location/vehicles',     name: 'vehicles',     component: require('./vehicles/base') },
    { path: '/:location/quotes',       name: 'quotes',       component: require('./quotes/base') },
  ],
})

var vue = new Vue({
  router,
  render: h => h(require('./layout/base')),
}).$mount('#gimmecar-app')
