var path = require('path')

module.exports = {
  mode: 'development',
  entry: './src/index.tsx',
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js'
  },
  resolve: {
    extensions: ['.js', '.jsx', '.tsx', '.ts', '.json', '.sol']
  },
  devServer: {
    contentBase: path.join(__dirname, '/dist/'),
    inline: true,
    host: '0.0.0.0',
    port: 3000
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: "awesome-typescript-loader",
        exclude: /(node_modules|bower_components)/,
      }
    ]
  }
}