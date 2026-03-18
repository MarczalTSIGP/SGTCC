class WelcomeMailer < ApplicationMailer
  def notify
    mail(to: 'dmarczal@gmail.com', subject: I18n.t('mailer.welcome.subject'))
  end
end
