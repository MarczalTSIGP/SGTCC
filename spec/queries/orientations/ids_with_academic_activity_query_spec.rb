require 'rails_helper'

RSpec.describe Orientations::IdsWithAcademicActivityQuery do
  let(:calendar) { create(:calendar, :tcc_one, year: '2036', semester: :one) }
  let(:orientation) { create(:orientation, calendars: [calendar]) }

  def submit_activity(activity_calendar, final_version:)
    activity = create(:activity, :proposal, calendar: activity_calendar, final_version:)
    create(:academic_activity, activity: activity, academic: orientation.academic)
  end

  describe '.call' do
    it 'includes the orientation with a final activity in its own calendar' do
      submit_activity(calendar, final_version: true)

      expect(described_class.call(:proposal).map(&:id)).to contain_exactly(orientation.id)
    end

    it 'ignores non-final activities by default' do
      submit_activity(calendar, final_version: false)

      expect(described_class.call(:proposal).map(&:id)).to be_empty
    end

    it 'returns non-final activities when they are requested' do
      submit_activity(calendar, final_version: false)

      expect(described_class.call(:proposal, final_version: false).map(&:id))
        .to contain_exactly(orientation.id)
    end

    it 'ignores activities from calendars outside the orientation' do
      submit_activity(create(:calendar, :tcc_one, year: '2030', semester: :one),
                      final_version: true)

      expect(described_class.call(:proposal).map(&:id)).to be_empty
    end

    it 'ignores activities with another identifier' do
      submit_activity(calendar, final_version: true)

      expect(described_class.call(:monograph).map(&:id)).to be_empty
    end
  end
end
