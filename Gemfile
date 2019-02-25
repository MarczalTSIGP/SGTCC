source 'https://rubygems.org'

ruby '2.5.3'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.2.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

gem 'active_link_to'
gem 'bootstrap', '~> 4.1.1'
gem 'breadcrumbs_on_rails'
gem 'bundle-audit', require: false
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-i18n'
gem 'devise'
gem 'devise-i18n'
gem 'font-awesome-sass'
gem 'htmlbeautifier'
gem 'jquery-rails'
gem 'kaminari'
gem 'mini_magick'
gem 'pg', '0.18.4'
gem 'rails-i18n'
gem 'reek', require: false
gem 'simple_form'
gem 'sassc-rails'
gem 'webpacker', '~> 3.5'
gem 'net-ldap'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails'
  gem 'geckodriver-helper'
  gem 'faker'
  gem 'rspec-rails', '~> 3.7'
  gem 'selenium-webdriver'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'populator', git: 'https://github.com/stephancom/populator.git', branch: 'rails-5'
  gem 'web-console', '>= 3.3.0'

  gem 'brakeman', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'bullet'
end

group :test do
  gem 'database_cleaner'
  gem 'guard-rspec', require: false
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
  gem 'shoulda-matchers', '~> 3.1'
end

group :production do
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
