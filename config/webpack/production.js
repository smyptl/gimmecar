var path    = require('path')
var webpack = require('webpack')
var merge   = require('webpack-merge')

var config = require('./base.js')

module.exports = merge(config, {
  output: {
    filename: "[name]-[hash].js"
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
