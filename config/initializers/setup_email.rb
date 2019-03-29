Rails.application.config.action_mailer.default_url_options = { host: ENV['mailer.host'],
                                                               port: ENV['mailer.host.port'] }
ActionMailer::Base.smtp_settings = {
  address: ENV['mailer.smtp'],
  port: ENV['mailer.smtp.port'],
  domain: ENV['mailer.smtp.domain'],
  user_name: ENV['mailer.smtp.username'],
  password: ENV['mailer.smtp.password'],
  authentication: ENV['mailer.smtp.authentication']
}
