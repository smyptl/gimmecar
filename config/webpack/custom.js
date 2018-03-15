const { resolve } = require('path')

module.exports =  {
  resolve: {
    alias: {
      Components: resolve('app/frontend/', 'components'),
      Filters:    resolve('app/frontend/', 'filters'),
      Utils:      resolve('app/frontend/', 'utils'),
      Styles:     resolve('app/frontend/', 'styles'),
      Admin:      resolve('app/frontend/', 'admin'),
      Command:    resolve('app/frontend/', 'command'),
      Public:     resolve('app/frontend/', 'public'),
    },
  },
}
