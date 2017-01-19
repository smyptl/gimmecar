import Promise from 'promise-polyfill'

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

const router = new VueRouter({
  linkActiveClass: 'active',
  routes: [
    { path: '/dashboard',    name: 'dashboard',    component: require('./dashboard/base') },
    { path: '/reservations', name: 'reservations', component: require('./reservations/base') },
    { path: '/rentals',      name: 'rentals',      component: require('./rentals/base') },
    { path: '/rates',        name: 'rates',        component: require('./rates/base') },
    { path: '/vehicles',     name: 'vehicles',     component: require('./vehicles/base') },
    { path: '/quotes',       name: 'quotes',       component: require('./quotes/base') },
  ],
})

new Vue({
  router,
  render: h => h(require('./layout/base')),
}).$mount('#gimmecar-app')
