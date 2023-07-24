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
end

# Switch between :chrome / :headless_chrome to see tests run in chrome
case ENV['HEADLESS']
when 'true', 1, nil
  # Capybara.current_driver = :headless_chrome
  Capybara.default_driver = :selenium
  Capybara.javascript_driver = :selenium
else
  Capybara.current_driver = :chrome
  Capybara.javascript_driver = :chrome
end

def app_host
  app = "http://#{ENV.fetch('TEST_APP_HOST', nil)}"
  port = Capybara.current_session.server.port
  "#{app}:#{port}"
end

Capybara.disable_animation = true
Capybara.server_host = '0.0.0.0'
Capybara.app_host = app_host
