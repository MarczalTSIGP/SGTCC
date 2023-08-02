require 'rails_helper'

describe ExternalMemberMailer, type: :mailer do
  describe 'registration email' do
    let(:password) { '123456' }
    let(:external_member) { create(:external_member) }

    let(:mail) do
      described_class.with(
        external_member: external_member, password: password
      ).registration_email.deliver_now
    end

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.external_member.registration.subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([external_member.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([ENV.fetch('mailer.from', nil)])
    end

    it 'assigns @name and @password' do
      expect(mail.body.encoded).to match(external_member.name)
      expect(mail.body.encoded).to match(password)
    end

    it 'assigns @login_url' do
      expect(mail.body.encoded)
        .to match(new_external_member_session_url)
    end
  end
end
