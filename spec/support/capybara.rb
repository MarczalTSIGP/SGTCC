def chrome_options
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-default-browser-check')
  options.add_argument('--start-maximized')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1366,768')
  options.add_argument('--headless') unless ENV['LAUNCH_BROWSER']
  options
end

def app_host
  app = "http://#{ENV.fetch('TEST_APP_HOST', nil)}"
  port = Capybara.current_session.server.port
  "#{app}:#{port}"
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: "http://#{ENV.fetch('SELENIUM_HOST',
                                                          nil)}:#{ENV.fetch('SELENIUM_PORT',
                                                                            nil)}/wd/hub",
                                 options: chrome_options)
end

Capybara.default_driver = :chrome
Capybara.javascript_driver = :chrome

Capybara.disable_animation = true
Capybara.server_host = '0.0.0.0'
Capybara.app_host = app_host
