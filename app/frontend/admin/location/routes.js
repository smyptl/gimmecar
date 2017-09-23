module.exports = {
  mode: 'history',
  linkActiveClass: 'active',
  routes: [
    { path: '/:location/dashboard',    name: 'dashboard',    component: require('./dashboard/base') },
    { path: '/:location/rentals/new',  name: 'new_rental',   component: require('./rentals/new/base') },
    { path: '/:location/rentals', component: require('./rentals/base'),
      children: [
        { path: '',        name: 'rentals', component: require('./rentals/index') },
        { path: ':number', name: 'rental',  component: require('./rentals/rental/index') },
      ],
    },
    { path: '/:location/reservations/new', name: 'new_reservation', component: require('./reservations/new/base') },
    {
      path: '/:location/reservations', component: require('./reservations/base'),
      children: [
        { path: '',    name: 'reservations',    component: require('./reservations/index') },
      ]
    },
    { path: '/:location/rates', name: 'rates', component: require('./rates/base') },
    { path: '/:location/vehicles', component: require('./vehicles/base'),
      children: [
        { path: '', name: 'vehicles', component: require('./vehicles/index') },
      ],
    },
  ],
}
