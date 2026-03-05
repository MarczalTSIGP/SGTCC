class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILER_FROM', nil)
  layout 'mailer'
end
