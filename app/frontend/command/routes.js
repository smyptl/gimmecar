module.exports = {
  mode: 'history',
  linkActiveClass: 'active',
  routes: [
    { path: '/', name: 'login', component: require('./login') },
    {
      path: '/',
      component: require('./layout/base'),
      children: [
        { path: '/dashboard', name: 'dashboard', component: require('./dashboard/base') },
        { path: '/rentals', component: require('./base'),
          children: [
            { path: '',        name: 'rentals', component: require('./rentals/index') },
            { path: ':number', name: 'rental',  component: require('./rentals/rental/index') },
          ],
        },
        { path: '/vehicles', component: require('./base'),
          children: [
            { path: '',     name: 'vehicles', component: require('./vehicles/index') },
            { path: ':vin', name: 'vehicle',  component: require('./vehicles/vehicle/index') },
          ],
        },
      ],
    },
  ],
}
