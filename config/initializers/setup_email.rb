Rails.application.config.action_mailer.default_url_options = { host: ENV.fetch('mailer.host', nil),
                                                               port: ENV.fetch('mailer.host.port',
                                                                               nil) }
ActionMailer::Base.smtp_settings = {
  address: ENV.fetch('mailer.smtp', nil),
  port: ENV.fetch('mailer.smtp.port', nil),
  domain: ENV.fetch('mailer.smtp.domain', nil),
  user_name: ENV.fetch('mailer.smtp.username', nil),
  password: ENV.fetch('mailer.smtp.password', nil),
  authentication: ENV.fetch('mailer.smtp.authentication', nil)
}
