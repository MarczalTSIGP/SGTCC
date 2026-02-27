class WelcomeMailer < ApplicationMailer

  def notify
    mail(to: "dmarczal@gmail.com", subject: "Welcome to SGTCC")
  end
end
