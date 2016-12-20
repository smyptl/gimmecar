var path = require('path');
var projectRoot = path.resolve(__dirname, '../');

module.exports = {
  entry: './app/frontend/index.js',
  output: {
    path: path.resolve(__dirname, './app/assets/javascripts'),
    publicPath: '/',
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue'
      },
    ],
  },
}
