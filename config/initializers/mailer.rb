return if Rails.env.test?

Rails.application.configure do
  config.action_mailer.delivery_method = ENV.fetch('MAILER_DELIVERY_METHOD', 'smtp').to_sym

  mailer = Rails.application.credentials.mailer
  config.action_mailer.smtp_settings = {
    domain: mailer&.domain,
    address: mailer&.address,
    port: mailer&.port,
    user_name: mailer&.user_name,
    password: mailer&.password,
    authentication: :login,
    enable_starttls_auto: true
  }
end
