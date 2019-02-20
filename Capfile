# Include default deployment tasks
require 'capistrano/setup'
require "capistrano/deploy"

# Include capistrano-rails
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require 'capistrano/rails/db'
require 'capistrano/yarn'
require 'capistrano/nvm'
require 'sshkit/sudo'


require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma

# # Load custom tasks from `lib/capistrano/tasks` if you have any defined
# Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
