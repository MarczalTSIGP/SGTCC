class ExternalMemberMailer < ApplicationMailer
  def registration_email
    @external_member = params[:external_member]
    @password = params[:password]
    mail(to: @external_member.email, subject: t('mailer.external_member.registration.subject'))
  end
end
