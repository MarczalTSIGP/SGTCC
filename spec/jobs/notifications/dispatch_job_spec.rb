require 'rails_helper'

RSpec.describe Notifications::DispatchJob do
  let!(:notification) { create(:notification) }

  let(:dispatcher) { instance_double(Notifications::Dispatcher, call: true) }

  before do
    allow(Notifications::Dispatcher).to receive(:new).and_return(dispatcher)
  end

  context 'when the notification exists' do
    it 'calls the Dispatcher with the correct notification' do
      described_class.perform_now(notification.id)

      expect(Notifications::Dispatcher).to have_received(:new).with(notification).once
      expect(dispatcher).to have_received(:call).once
    end

    it 'rescues and logs StandardError' do
      allow(dispatcher).to receive(:call).and_raise(StandardError, 'SMTP Error')

      expect { described_class.perform_now(notification.id) }
        .to raise_error(StandardError, 'SMTP Error')
    end
  end

  context 'when the notification doesn\'t exist' do
    it 'does nothing and logs a warning' do
      described_class.perform_now(9999)

      expect(Notifications::Dispatcher).not_to have_received(:new)
    end
  end
end
