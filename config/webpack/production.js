var path    = require('path')
var webpack = require('webpack')
var merge   = require('webpack-merge')

var config = require('./base.js')

module.exports = merge(config, {
  output: {
    path: path.resolve(__dirname, '../../public/packs'),
    filename: "[name]-[hash].js",
    publicPath: '/',
  },

  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    }),
    new webpack.LoaderOptionsPlugin({
      minimize: true
    }),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      }
    }),
  ],
})
