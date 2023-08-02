class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('mailer.from', nil)
  layout 'mailer'
end
