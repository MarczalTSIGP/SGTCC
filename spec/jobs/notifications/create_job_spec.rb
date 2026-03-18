require 'rails_helper'

RSpec.describe Notifications::CreateJob do
  let(:scheduler_service) { instance_double(Notifications::SchedulerService, schedule!: true) }
  let!(:recipient) { ApplicationRecord.connected_to(role: :writing) { create(:academic) } }
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

  it 'calls SchedulerService with the correct arguments' do
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

  it 'rescues and logs StandardError' do
    allow(scheduler_service).to receive(:schedule!).and_raise(StandardError, 'Erro de Teste')

    allow(Rails.logger).to receive(:error)

    expect { described_class.perform_now(**job_args) }.not_to raise_error
    expect(Rails.logger).to have_received(:error)
      .with(a_string_including('Failed to create notification: Erro de Teste'))
  end
end
