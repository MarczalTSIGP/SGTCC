require 'rails_helper'

RSpec.describe Notifications::DailyDeadlineJob, type: :job do
  it 'chama o hook de daily_deadline_notifications' do
    hooks_spy = class_spy(Notifications::Hooks::Activity).as_stubbed_const
    
    described_class.perform_now
    
    expect(hooks_spy).to have_received(:daily_deadline_notifications).once
  end
end