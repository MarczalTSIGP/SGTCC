require 'rails_helper'

RSpec.describe Notifications::DispatchJob, type: :job do
  let!(:notification) { create(:notification) }

  let(:dispatcher) { instance_double(Notifications::Dispatcher, call: true) }

  before do
    allow(Notifications::Dispatcher).to receive(:new).and_return(dispatcher)
  end

  context 'quando a notificação existe' do
    it 'chama o Dispatcher com a notificação correta' do
      described_class.perform_now(notification.id)
      
      expect(Notifications::Dispatcher).to have_received(:new).with(notification).once
      expect(dispatcher).to have_received(:call).once
    end

   it 're-levanta o erro se o Dispatcher falhar (para retries)' do
    allow(dispatcher).to receive(:call).and_raise(StandardError, 'Erro de SMTP')

    expect { described_class.perform_now(notification.id) }
      .to raise_error(StandardError, 'Erro de SMTP')
    end
  end

  context 'quando a notificação não existe' do
    it 'não faz nada e loga um aviso' do
      
      described_class.perform_now(9999)
      
      expect(Notifications::Dispatcher).not_to have_received(:new)
    end
  end
end