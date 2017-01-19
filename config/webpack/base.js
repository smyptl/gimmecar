var path = require('path')
var projectRoot = path.resolve(__dirname, '../../')

var webpack = require("webpack")

module.exports = {
  entry: {
    public: './app/frontend/public/index',
    admin: [
      './app/frontend/admin/index',
      'webpack-hot-middleware/client?path=http://localhost:8080/__webpack_hmr&noInfo=true&reload=true',
    ]
  },
  output: {
    path: path.resolve(__dirname, '../../public/assets'),
    filename: '[name].js',
    publicPath: '/',
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        use: 'vue-loader',
      },
      {
        test: /\.js$/,
        use: 'babel-loader',
      },
      {
        test: /\.styl$/,
        use: ["style-loader", "css-loader", "postcss-loader", "stylus-loader"],
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.vue', '.styl'],
    alias: {
      Components: path.resolve(__dirname, '../../app/frontend/components'),
      Filters:    path.resolve(__dirname, '../../app/frontend/filters'),
      Utils:      path.resolve(__dirname, '../../app/frontend/utils'),
      Styles:     path.resolve(__dirname, '../../app/frontend/styles'),
      Admin:      path.resolve(__dirname, '../../app/frontend/admin'),
    },
  },
  plugins: [
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
  ],
}
