require 'rails_helper'

RSpec.describe MeetingPolicy do
  let(:professor) { build(:professor) }

  it 'allows update and destroy before the academic views the meeting' do
    policy = described_class.new(professor, build(:meeting, viewed: false))
    expect([policy.update?, policy.destroy?]).to eq([true, true])
  end

  it 'denies update and destroy after the academic views the meeting' do
    policy = described_class.new(professor, build(:meeting, viewed: true))
    expect([policy.update?, policy.destroy?]).to eq([false, false])
  end
end
