# Capybara.register_driver :firefox_headless do |app|
#   options = ::Selenium::WebDriver::Firefox::Options.new
#   options.args << '--headless'
#
#   Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
# end
#
# Capybara.javascript_driver = :firefox_headless

# require 'capybara/apparition'
# # Capybara.javascript_driver = :apparition
#
# Capybara.javascript_driver = :apparition
# Capybara.register_driver :apparition do |app|
#   Capybara::Apparition::Driver.new(app, headless: true, js_errors: false, debug: false)
# end
Capybara.server = :puma, { Silent: true }

# Chrome non-headless driver
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# Chrome headless driver
Capybara.register_driver :headless_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
  opts = Selenium::WebDriver::Chrome::Options.new

  chrome_args = %w[--headless --no-sandbox --disable-gpu --window-size=1920,1080 --remote-debugging-port=9222]
  chrome_args.each { |arg| opts.add_argument(arg) }
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts, desired_capabilities: caps)
end

# Switch between :chrome / :headless_chrome to see tests run in chrome
case ENV['HEADLESS']
when 'true', 1, nil
  Capybara.current_driver = :headless_chrome
  Capybara.javascript_driver = :headless_chrome
else
  Capybara.current_driver = :chrome
  Capybara.javascript_driver = :chrome
end
