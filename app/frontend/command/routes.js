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
        { path: '/rentals',   name: 'rentals',   component: require('./rentals/index') },
        { path: '/vehicles',  name: 'vehicles',  component: require('./vehicles/index') },
      ],
    },
  ],
}
