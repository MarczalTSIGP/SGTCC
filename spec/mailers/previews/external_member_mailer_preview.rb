class ExternalMemberMailerPreivew < ActionMailer::Preview
  # Preview all emails at http://localhost:3000/rails/mailers
  def registration_email
    ExternalMemberMailer.with(external_member: ExternalMember.first, password: '1234')
                        .registration_email
  end
end
