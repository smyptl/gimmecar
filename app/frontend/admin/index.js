import Promise from 'promise-polyfill'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import Axios from 'axios'
Axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
Axios.defaults.headers.common['X-CSRF-Token'] = document.getElementsByName('csrf-token')[0].content
Vue.prototype.$http = Axios

const router = new VueRouter({
  mode: 'history',
  linkActiveClass: 'active',
  routes: [
    {
      path: '/', name: 'login', component: require('./login/base'),
    },
    {
      path: '/:location',
      component: require('./location/layout/base'),
      children: [
        { path: 'dashboard',    name: 'dashboard',    component: require('./location/dashboard/base') },
        { path: 'reservations', name: 'reservations', component: require('./location/reservations/base') },
        { path: 'rentals',      name: 'rentals',      component: require('./location/rentals/base') },
        { path: 'rates',        name: 'rates',        component: require('./location/rates/base') },
        { path: 'vehicles',     name: 'vehicles',     component: require('./location/vehicles/base') },
        { path: 'quotes',       name: 'quotes',       component: require('./location/quotes/base') },
      ],
    },
  ],
})

var vue = new Vue({
  router,
  render: h => h(require('./layout')),
}).$mount('#gimmecar-app')
