var path = require('path')
var projectRoot = path.resolve(__dirname, '../../')

var webpack = require("webpack")

module.exports = {
  entry: {
    public: './app/frontend/public/index',
    admin_login: './app/frontend/admin/login/index',
    admin_location: './app/frontend/admin/location/index',
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
        use: [
          "style-loader",
          "css-loader",
          {
            loader: 'postcss-loader',
            options: {
              plugins () {
                return [
                  require('precss'),
                  require('autoprefixer'),
                ];
              }
            }
          },
          "stylus-loader",
        ],
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
