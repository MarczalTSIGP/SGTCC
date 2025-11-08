require 'rails_helper'

RSpec.describe Notifications::Dispatcher, type: :service do
  let(:notification) { create(:notification, notification_type: template.key) }
  let(:template) { create(:notification_template, channel: 'email') }

  let(:mailer_double) { instance_double(ActionMailer::MessageDelivery) }

  before do
    allow(NotificationMailer).to receive(:generic_email).with(notification.id)
                                                        .and_return(mailer_double)
    allow(mailer_double).to receive(:deliver_later)
  end

  it 'calls NotificationMailer for email channel' do
    described_class.new(notification).call

    expect(NotificationMailer).to have_received(:generic_email).with(notification.id)
    expect(mailer_double).to have_received(:deliver_later).with(queue: :mailers)
  end

  it 'logs a warning for an unknown channel' do
    template.update!(channel: 'invalid_channel')

    allow(Rails.logger).to receive(:warn)

    described_class.new(notification).call

    expect(Rails.logger).to have_received(:warn)
      .with(a_string_including('Unknown channel: invalid_channel'))
    expect(NotificationMailer).not_to have_received(:generic_email)
  end

  it 're-raises the error if the Mailer fails (for the Job to handle)' do
    allow(NotificationMailer).to receive(:generic_email).and_raise(StandardError, 'SMTP Error')

    allow(Rails.logger).to receive(:error)

    expect do
      described_class.new(notification).call
    end.to raise_error(StandardError, 'SMTP Error')

    expect(Rails.logger).to have_received(:error).with(a_string_including('SMTP Error'))
  end
end
