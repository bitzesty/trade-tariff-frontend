module.exports = {
  test: /\.erb$/,
  enforce: 'pre',
  exclude: /node_modules/,
  use: [{
    loader: 'rails-erb-loader',
    options: {
      runner: (/^win/.test(process.platform) ? 'ruby ' : '') + 'bin/rails runner'
      // dependenciesRoot: '../app'
    }
  }]
}


// const { dev_server: devServer } = require('@rails/webpacker').config
//
// const isProduction = process.env.NODE_ENV === 'production'
// const inDevServer = process.argv.find(v => v.includes('webpack-dev-server'))
// const extractCSS = !(inDevServer && (devServer && devServer.hmr)) || isProduction
//
// module.exports = {
//   test: /\.vue(\.erb)?$/,
//   use: [{
//     loader: 'vue-loader',
//     options: { extractCSS }
//   },
//   {
//     loader: 'rails-erb-loader',
//     options: {
//       runner: 'bin/rails runner',
//       dependenciesRoot: '../app'
//     }
//   }
// ]
// }
