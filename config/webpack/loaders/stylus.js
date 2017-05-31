const ExtractTextPlugin = require('extract-text-webpack-plugin')
const { env } = require('../configuration.js')

module.exports = {
  test: /\.styl$/,
  use: ExtractTextPlugin.extract({
    fallback: 'style-loader',
    use: [
      { loader: 'css-loader', options: { minimize: env.NODE_ENV === 'production' } },
      { loader: 'postcss-loader', options: { sourceMap: true } },
      'resolve-url-loader',
      'stylus-loader',
    ],
  })
}
