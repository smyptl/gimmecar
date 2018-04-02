export default {
  mode: 'history',
  linkActiveClass: 'active',
  routes: [
    { path: '/', name: 'login', component: require('./login').default },
    {
      path: '/',
      component: require('./layout/base').default,
      children: [
        { path: '/dashboard', name: 'dashboard', component: require('./dashboard/base').default },
        { path: '/rentals', component: require('./base').default,
          children: [
            { path: '',        name: 'rentals', component: require('./rentals/index').default },
            { path: ':number', name: 'rental',  component: require('./rentals/show').default },
          ],
        },
        { path: '/vehicles', component: require('./base').default,
          children: [
            { path: '',     name: 'vehicles', component: require('./vehicles/index').default },
            { path: ':vin', name: 'vehicle',  component: require('./vehicles/show').default },
          ],
        },
        { path: '/drivers', component: require('./base').default,
          children: [
            { path: '',     name: 'drivers', component: require('./drivers/index').default },
            { path: ':id',  name: 'driver',  component: require('./drivers/show').default },
          ],
        },
        {
          path: '/locations', name: 'locations', component: require('./locations/index').default
        },
        {
          path: '/reports', name: 'reports', component: require('./reports/index').default
        },
        {
          path: '/quote', name: 'quote', component: require('./quote/index').default,
        },
      ],
    },
  ],
}
