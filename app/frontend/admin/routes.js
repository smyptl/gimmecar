module.exports = {
  mode: 'history',
  linkActiveClass: 'active',
  routes: [
    { path: '/', name: 'login', component: require('./login') },
    { path: '/locations', name: 'locations',  component: require('./locations') },
    {
      path: '/:location',
      component: require('./location/layout/base'),
      children: [
        { path: '/:location/dashboard',   name: 'dashboard',  component: require('./location/dashboard/base') },
        { path: '/:location/rentals/new', name: 'new_rental', component: require('./location/rentals/new/base') },
        { path: '/:location/rentals', component: require('./base'),
          children: [
            { path: '',        name: 'rentals', component: require('./location/rentals/index') },
            { path: ':number', name: 'rental',  component: require('./location/rentals/show') },
          ],
        },
        { path: '/:location/reservations/new', name: 'new_reservation', component: require('./base') },
        {
          path: '/:location/reservations', component: require('./base'),
          children: [
            { path: '',    name: 'reservations',    component: require('./location/reservations/index') },
          ]
        },
        { path: '/:location/rates', name: 'rates', component: require('./location/rates/index') },
        { path: '/:location/vehicles', component: require('./base'),
          children: [
            { path: '',     name: 'vehicles', component: require('./location/vehicles/index') },
            { path: ':vin', name: 'vehicle',  component: require('./location/vehicles/show') },
          ],
        },
      ],
    }
  ],
}
