Capybara.configure do |config|
  config.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i
end
Capybara.register_driver :firefox_headless do |app|
  options = ::Selenium::WebDriver::Firefox::Options.new
  options.args << '--headless'

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.javascript_driver = :firefox_headless
