var path = require('path');
var projectRoot = path.resolve(__dirname, '../');

var webpack = require("webpack");

module.exports = {
  entry: {
    public: './app/frontend/public/index',
    admin: './app/frontend/admin/index',
  },
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
      'Admin':      path.resolve(__dirname, '../app/frontend/admin'),
    },
  },
  devtool: 'source-map',
  plugins: [
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
    new webpack.HotModuleReplacementPlugin(),

  ],
}

if (process.env.NODE_ENV === 'production') {
  module.exports.plugins.push(
  new webpack.optimize.UglifyJsPlugin({
      sourcemap: true,
      compress: {
        warnings: false
      }
    })
  )

  module.exports.plugins.push(
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    })
  )
}
