var webpack = require('webpack')
var merge   = require('webpack-merge')
var config  = require('./base.js')

config = merge(config, {
  devtool: 'sourcemap',
  devServer: {
    hot: true,
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
