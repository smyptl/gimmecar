const { environment } = require('@rails/webpacker')
const custom = require('./custom.js')
const babel = require('./loaders/babel')
const stylus = require('./loaders/stylus')
const vue = require('./loaders/vue')

environment.loaders.append('vue', vue)
environment.loaders.append('styl', stylus)
environment.loaders.append('js', babel)

environment.config.merge(custom)

module.exports =  environment
