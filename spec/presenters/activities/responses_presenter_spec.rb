require 'rails_helper'

RSpec.describe Activities::ResponsesPresenter do
  subject(:presenter) { described_class.new(activity) }

  describe 'academics of the activity calendar' do
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
      academics = presenter.academics
      expect(academics.pluck(:id)).to contain_exactly(academic_one.id, academic_two.id)
    end

    it 'have total that should sent' do
      expect(presenter.total_should_sent).to eq(2)
    end

    it 'have total of sent' do
      expect(presenter.total_sent).to eq(0)
    end

    it 'has an academic response with property sent' do
      # Cria um academic_activity para academic_one, marcando como enviado
      create(:academic_activity, academic: academic_one, activity: activity)

      academic_response_one = presenter.academics.find { |a| a.id == academic_one.id }
      academic_response_two = presenter.academics.find { |a| a.id == academic_two.id }

      expect(academic_response_one.sent?).to be(true)
      expect(academic_response_two.sent?).to be(false)
      expect(presenter.total_sent).to eq(1)
    end
  end

  describe '#entries_info' do
    let(:activity) { create(:activity) }

    it 'returns a dash when the activity does not receive documents' do
      allow(activity.base_activity_type).to receive(:send_document?).and_return(false)

      expect(presenter.entries_info).to eq('-')
    end

    it 'returns sent over expected when the activity receives documents' do
      allow(activity.base_activity_type).to receive(:send_document?).and_return(true)

      expect(presenter.entries_info)
        .to eq("0 de 0 #{Activity.human_attribute_name(:sent, count: 0)}")
    end
  end
end
