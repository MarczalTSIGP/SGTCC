require 'rails_helper'

RSpec.describe NotificationMailer do
  describe '#generic_email' do
    subject(:mail) { described_class.generic_email(notification.id) }

    let(:recipient) { create(:professor, email: 'professor@example.com') }
    let(:template) do
      create(
        :notification_template,
        key: 'submission_alert',
        subject: 'Alerta de Submissão: %<title>s',
        body: '<p>Olá %<name>s,</p><p>Seu trabalho "%<title>s" foi enviado.</p>'
      )
    end

    let(:notification) do
      create(
        :notification,
        notification_type: template.key,
        recipient: recipient,
        data: { name: 'Prof. João', title: 'Relatório Final' }
      )
    end

    before do
      allow(Rails.application.credentials).to receive(:mailer).and_return(
        { from: 'tcc-tsi-gp@utfpr.edu.br' }
      )
      ActionMailer::Base.deliveries.clear
      mail.deliver_now
    end

    it 'envia o e-mail para o destinatário correto' do
      expect(mail.to).to contain_exactly(recipient.email)
    end

    it 'usa o assunto formatado com o payload' do
      expect(mail.subject).to eq('[SGTCC] Alerta de Submissão: Relatório Final')
    end

    it 'renderiza o corpo HTML com as variáveis interpoladas' do
      html = CGI.unescapeHTML(mail.html_part.body.to_s)
      expect(html)
        .to include('<p>Olá Prof. João,</p>')
        .and include('<p>Seu trabalho "Relatório Final" foi enviado.</p>')
    end

    it 'renderiza a versão em texto puro' do
      expect(mail.text_part.body.to_s)
        .to include('Olá Prof. João')
        .and include('Seu trabalho "Relatório Final" foi enviado.')
    end

    it 'usa o remetente padrão configurado' do
      expect(mail.from).to include('tcc-tsi-gp@utfpr.edu.br')
    end

    it 'adiciona o e-mail à fila de envios (deliveries)' do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.to).to eq([recipient.email])
    end
  end

  describe 'erros de interpolação' do
    let(:recipient) { create(:professor, email: 'erro@example.com') }
    let(:template) do
      create(:notification_template, key: 'broken', subject: 'Olá %<nome>s', body: 'Corpo %<nome>s')
    end

    let(:notification) do
      create(
        :notification,
        notification_type: template.key,
        recipient: recipient,
        data: { wrong_key: 'sem nome' }
      )
    end

    it 'gera erro se o data não possui a chave necessária' do
      expect do
        described_class.generic_email(notification.id).deliver_now
      end.to raise_error(KeyError, /nome/)
    end
  end
end
