const webpackerConfig = require('../config/webpack/development')

module.exports = {
  module: webpackerConfig.module,
  plugins: webpackerConfig.plugins,
  resolve: webpackerConfig.resolve
}
