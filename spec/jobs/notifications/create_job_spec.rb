require 'rails_helper'

RSpec.describe Notifications::CreateJob, type: :job do
  let(:scheduler_service) { instance_double(Notifications::SchedulerService, schedule!: true) }
  let(:recipient) { create(:academic) }
  let(:job_args) do
    {
      notification_type: 'test_notification',
      recipient: recipient,
      event_key: 'test:123',
      data: { foo: 'bar' },
      scheduled_at: Time.current
    }
  end

  before do
    allow(Notifications::SchedulerService).to receive(:new).and_return(scheduler_service)
  end

  it 'chama o SchedulerService com os argumentos corretos' do
    described_class.perform_now(**job_args)

    expect(Notifications::SchedulerService).to have_received(:new).with(
      notification_type: 'test_notification',
      recipient: recipient,
      event_key: 'test:123',
      data: { foo: 'bar' },
      scheduled_at: job_args[:scheduled_at]
    )
    
    expect(scheduler_service).to have_received(:schedule!).once
  end

  it 'resgata e loga erros StandardError' do
    allow(scheduler_service).to receive(:schedule!).and_raise(StandardError, 'Erro de Teste')

    expect(Rails.logger).to receive(:error).with(a_string_including('Failed to create notification: Erro de Teste'))

    expect { described_class.perform_now(**job_args) }.not_to raise_error
  end
end