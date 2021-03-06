const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')
const coffee =  require('./loaders/coffee')
const vue =  require('./loaders/vue')

const customConfig = require('./custom')

const VueLoaderPlugin = require('vue-loader/lib/plugin')
environment.plugins.append(
  'VueLoaderPlugin',
  new VueLoaderPlugin()
)

// Merge custom config
environment.config.merge(customConfig)

environment.loaders.append('vue', vue)
environment.loaders.append('coffee', coffee)
environment.loaders.append('erb', erb)
module.exports = environment
