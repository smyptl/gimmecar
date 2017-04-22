module.exports = {
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
}
