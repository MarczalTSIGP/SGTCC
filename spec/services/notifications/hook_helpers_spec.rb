require 'rails_helper'

RSpec.describe Notifications::HookHelpers, type: :service do
  include ActiveJob::TestHelper

  let(:test_class) do
    Class.new do
      extend Notifications::HookHelpers
    end
  end
  let(:recipient) { create(:academic) }

  it '#schedule_notification enqueues a CreateJob with correct arguments' do
    args = {
      notification_type: 'teste',
      recipient: recipient,
      data: { foo: 'bar' },
      event_key: 'key:1'
    }

    expect do
      test_class.schedule_notification(**args)
    end.to have_enqueued_job(Notifications::CreateJob).with(
      notification_type: 'teste',
      recipient: recipient,
      data: { foo: 'bar' },
      event_key: 'key:1'
    )
  end

  it '#event_key formats the key correctly' do
    key = test_class.event_key('doc', 1, 'user', 5)
    expect(key).to eq('doc:1:user:5')
  end

  it '#user_identifier formats the user identifier correctly' do
    identifier = test_class.user_identifier(recipient)
    expect(identifier).to eq("Academic:#{recipient.id}")
  end

  it '#class_name_lower formats the class name correctly' do
    name = test_class.class_name_lower(recipient)
    expect(name).to eq('academic')
  end
end
