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
    {
      path: '/', name: 'login', component: require('./login/base'),
      beforeEnter: (to, from, next) => {
        if (USER.name && LOCATION.slug) {
          next({ path: 'dashboard', params: { location: LOCATION.slug } })
        } else if (USER.name) {
          next({ path: 'locations' })
        } else {
          next()
        }
      }
    },
    {
      path: '/locations', name: 'locations', component: require('./locations/base'),
      beforeEnter: (to, from, next) => {
        next()
      },
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
      beforeEnter: (to, from, next) => {
        if (!USER.name) {
          return next({ name: 'login' })
        } else if (!LOCATION.slug) {
          return next({ name: 'locations' })
        } else {
          return next()
        }
      },
    },
  ],
})

var vue = new Vue({
  router,
  render: h => h(require('./layout')),
}).$mount('#gimmecar-app')
