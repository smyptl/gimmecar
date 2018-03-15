export default {
  mode: 'history',
  linkActiveClass: 'active',
  routes: [
    { path: '/', name: 'login', component: require('./login').default },
    { path: '/locations', name: 'locations',  component: require('./locations').default },
    {
      path: '/:location',
      component: require('./location/layout/base').default,
      children: [
        { path: '/:location/dashboard',   name: 'dashboard',  component: require('./location/dashboard/base').default },
        { path: '/:location/rentals/new', name: 'new_rental', component: require('./location/rentals/new/base').default },
        { path: '/:location/rentals', component: require('./base').default,
          children: [
            { path: '',        name: 'rentals', component: require('./location/rentals/index').default },
            { path: ':number', name: 'rental',  component: require('./location/rentals/show').default },
          ],
        },
        { path: '/:location/reservations/new', name: 'new_reservation', component: require('./base').default },
        {
          path: '/:location/reservations', component: require('./base').default,
          children: [
            { path: '',    name: 'reservations',    component: require('./location/reservations/index').default },
          ]
        },
        { path: '/:location/quote', name: 'quote', component: require('./location/quote/index').default },
        { path: '/:location/vehicles', component: require('./base').default,
          children: [
            { path: '',     name: 'vehicles', component: require('./location/vehicles/index').default },
            { path: ':vin', name: 'vehicle',  component: require('./location/vehicles/show').default },
          ],
        },
      ],
    }
  ],
}
