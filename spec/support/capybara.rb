<<<<<<< HEAD
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
=======
# Capybara.server = :puma, { Silent: true }

# Chrome non-headless driver
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# Chrome headless driver
Capybara.register_driver :selenium do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
  opts = Selenium::WebDriver::Chrome::Options.new

  chrome_args = %w[--headless --no-sandbox --disable-gpu --window-size=1920,1080
                   --disable-dev-shm-usage --remote-debugging-port=9222]

  chrome_args.each { |arg| opts.add_argument(arg) }
  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub",
    options: opts, desired_capabilities: caps)
>>>>>>> 520c03b6a9b218475c2b05d56fca6662d80efb82
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: "http://#{ENV.fetch('SELENIUM_HOST',
                                                          nil)}:#{ENV.fetch('SELENIUM_PORT',
                                                                            nil)}/wd/hub",
                                 options: chrome_options)
end

<<<<<<< HEAD
Capybara.default_driver = :chrome
Capybara.javascript_driver = :chrome

Capybara.disable_animation = true
Capybara.server_host = '0.0.0.0'
Capybara.app_host = app_host
=======
def app_host
  app = "http://#{ENV.fetch('TEST_APP_HOST', nil)}"
  port = Capybara.current_session.server.port
  "#{app}:#{port}"
end

Capybara.disable_animation = true
Capybara.server_host = '0.0.0.0'
Capybara.app_host = app_host
>>>>>>> 520c03b6a9b218475c2b05d56fca6662d80efb82
