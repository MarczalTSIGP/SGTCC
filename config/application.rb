require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SistemaGestaoTcc
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.exceptions_app = routes

    config.autoload_paths += Dir["#{config.root}/lib/devise/"]
    config.autoload_paths += Dir["#{config.root}/lib/builders/"]
    config.eager_load_paths += Dir["#{config.root}/lib/builders/"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.time_zone = 'Brasilia'

    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = ['pt-BR']
    config.i18n.default_locale = :'pt-BR'

    config.active_record.schema_format = :sql

    ENV.update YAML.load_file('config/application.yml')[Rails.env]
  end
end
