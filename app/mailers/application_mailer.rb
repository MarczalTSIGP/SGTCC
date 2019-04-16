class ApplicationMailer < ActionMailer::Base
  default from: ENV['mailer.from']
  layout 'mailer'
end
