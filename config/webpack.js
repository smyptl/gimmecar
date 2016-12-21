var path = require('path');
var projectRoot = path.resolve(__dirname, '../');

module.exports = {
  entry: './app/frontend/public/index.js',
  output: {
    path: path.resolve(__dirname, '../app/assets/javascripts'),
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader',
      },
      {
        test: /\.s[a|c]ss$/,
        loader: ["style-loader", "css-loader", "sass-loader"],
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.vue'],
    alias: {
      'Components': path.resolve(__dirname, '../app/frontend/components'),
    },
  },
}
