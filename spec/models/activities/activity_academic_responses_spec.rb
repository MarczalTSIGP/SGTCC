require 'rails_helper'

RSpec.describe Activity do
  describe '#academic_activity' do
    let(:activity) { create(:activity) }
    let(:orientation) { create(:orientation) }

    let!(:academic_activity) do
      create(:academic_activity, activity:, academic: orientation.academic)
    end

    it 'returns the academic activity' do
      expect(activity.academic_activity(orientation)).to eq(academic_activity)
    end
  end

  describe '.find_academic_activity_by_academic' do
    let!(:academic_activity) { create(:academic_activity) }

    it 'returns the academic activity' do
      activity = academic_activity.activity
      academic = academic_activity.academic
      expect(activity.find_academic_activity_by_academic(academic)).to eq(academic_activity)
    end
  end

  describe '#academic_responses' do
    let(:activity) { create(:activity) }

    let(:academic_one) { create(:academic, name: 'A') }
    let(:academic_two) { create(:academic, name: 'B') }

    let(:orientation_one) do
      create(:orientation, academic: academic_one, skip_calendar_association: true)
    end
    let(:orientation_two) do
      create(:orientation, academic: academic_two, skip_calendar_association: true)
    end

    before do
      orientation_one.calendars.clear
      orientation_two.calendars.clear

      activity_calendar = activity.calendar

      orientation_one.calendars << activity_calendar
      orientation_two.calendars << activity_calendar
    end

    it 'returns all academics associated with the calendar' do
      academics = activity.responses.academics
      expect(academics.pluck(:id)).to contain_exactly(academic_one.id, academic_two.id)
    end

    it 'have total that should sent' do
      expect(activity.responses.total_should_sent).to eq(2)
    end

    it 'have total of sent' do
      expect(activity.responses.total_sent).to eq(0)
    end

    it 'has an academic response with property sent' do
      # Cria um academic_activity para academic_one, marcando como enviado
      create(:academic_activity, academic: academic_one, activity: activity)

      academic_response_one = activity.responses.academics.find { |a| a.id == academic_one.id }
      academic_response_two = activity.responses.academics.find { |a| a.id == academic_two.id }

      expect(academic_response_one.sent?).to be(true)
      expect(academic_response_two.sent?).to be(false)
      expect(activity.responses.total_sent).to eq(1)
    end
  end
end
