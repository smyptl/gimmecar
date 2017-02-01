var path = require('path')

var webpack = require('webpack')
var merge   = require('webpack-merge')
var config  = require('./base.js')
var _       = require('lodash')

_.forEach(Object.keys(config.entry), function (name) {
  var hot_reload = 'webpack-hot-middleware/client?path=http://localhost:8080/__webpack_hmr&noInfo=true&reload=true'

  if (_.isArray(config.entry[name])) {
    config.entry[name].push(hot_reload)
  } else {
    config.entry[name] = [config.entry[name], hot_reload]
  }
})

config = merge(config, {
  devtool: 'sourcemap',
  devServer: {
    hot: true,
  },
  output: {
    path: path.resolve(__dirname, '../../public/assets'),
    filename: '[name].js',
    publicPath: 'http://localhost:8080/'
  },
  stats: {
    errorDetails: true
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NamedModulesPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
  ],
})

var express = require('express')

var app = express()
var compiler = webpack(config);

app.use(require('webpack-dev-middleware')(compiler, {
  publicPath: config.output.publicPath,
  quiet: true,
}))

app.use(require('webpack-hot-middleware')(compiler))

app.listen(8080)

module.exports = config
