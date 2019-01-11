const { environment } = require('@rails/webpacker');
const vue =  require('./loaders/vue');
const eslint = require('./loaders/eslint');

environment.loaders.append('vue', vue);
module.exports = environment;
