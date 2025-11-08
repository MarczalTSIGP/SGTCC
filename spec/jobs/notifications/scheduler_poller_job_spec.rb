require 'rails_helper'

RSpec.describe Notifications::SchedulerPollerJob do
  include ActiveSupport::Testing::TimeHelpers

  let(:processor_instance_spy) { instance_double(Notifications::ProcessorService, process: true) }

  before do
    allow(Notifications::ProcessorService).to receive(:new)
      .with(anything).and_return(processor_instance_spy)
  end

  it 'chama o ProcessorService para cada notificação pendente' do
    freeze_time do
      notification_pending = create(:notification, status: 'pending')
      notification_scheduled_past = create(:notification, status: 'scheduled',
                                                          scheduled_at: 1.hour.ago)

      create(:notification, status: 'scheduled', scheduled_at: 1.hour.from_now)
      create(:notification, status: 'sent')

      described_class.perform_now

      aggregate_failures 'chama ProcessorService corretamente' do
        expect(Notifications::ProcessorService)
          .to have_received(:new).with(notification_pending).once

        expect(Notifications::ProcessorService)
          .to have_received(:new).with(notification_scheduled_past).once

        expect(Notifications::ProcessorService).to have_received(:new).exactly(2).times
      end

      expect(processor_instance_spy).to have_received(:process).with(no_args).exactly(2).times
    end
  end

  it 'não chama o ProcessorService se não houver notificações pendentes' do
    freeze_time do
      create(:notification, status: 'sent')
      create(:notification, status: 'scheduled', scheduled_at: 1.hour.from_now)

      described_class.perform_now

      expect(Notifications::ProcessorService).not_to have_received(:new)
      expect(processor_instance_spy).not_to have_received(:process)
    end
  end
end
