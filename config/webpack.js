var path = require('path');
var projectRoot = path.resolve(__dirname, '../');

var webpack = require("webpack");

module.exports = {
  entry: './app/frontend/public/index',
  output: {
    path: path.resolve(__dirname, '../app/assets/javascripts'),
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader',
      },
      {
        test: /\.js$/,
        loader: 'babel-loader',
      },
      {
        test: /\.styl$/,
        loader: ["style-loader", "css-loader", "postcss-loader", "stylus-loader"],
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.vue', '.styl'],
    alias: {
      'Components': path.resolve(__dirname, '../app/frontend/components'),
      'Filters':    path.resolve(__dirname, '../app/frontend/filters'),
      'Utils':      path.resolve(__dirname, '../app/frontend/utils'),
      'Styles':     path.resolve(__dirname, '../app/frontend/styles'),
    },
  },
  devtool: 'source-map',
  plugins: [
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
  ],
}
