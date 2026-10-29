require 'rails_helper'

RSpec.describe Orientations::MigrationService do
  before do
    Calendar.delete_all
    Orientation.delete_all
    OrientationCalendar.delete_all
  end

  describe '.call' do
    context 'when orientation is not APPROVED_TCC_ONE' do
      it 'returns not migrated with wrong_status reason' do
        orientation = create(:orientation)
        result = described_class.call(orientation)

        expect(result.migrated).to be(false)
        expect(result.reason).to eq(:wrong_status)
      end
    end

    context 'when no next TCC two calendar exists' do
      it 'returns not migrated with no_next_calendar reason' do
        calendar = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:one]
        )
        orientation = create(:orientation, calendars: [calendar], status: 'APPROVED_TCC_ONE')

        result = described_class.call(orientation)

        expect(result.migrated).to be(false)
        expect(result.reason).to eq(:no_next_calendar)
      end
    end

    context 'when next TCC two calendar exists' do
      before { travel_to Date.new(2025, 8, 1) }

      let!(:current_tcc_one) do
        create(:calendar, year: '2025', semester: 'two', tcc: :one,
                          start_date: Date.new(2025, 7, 1), end_date: Date.new(2025, 12, 31))
      end

      let!(:next_tcc_two) do
        create(:calendar, year: '2026', semester: 'one', tcc: :two,
                          start_date: Date.new(2026, 1, 1), end_date: Date.new(2026, 6, 30))
      end

      let!(:orientation) do
        create(:orientation, :approved_tcc_one, :with_final_project,
               calendars: [current_tcc_one])
      end

      it 'returns migrated true' do
        result = described_class.call(orientation)
        expect(result.migrated).to be(true)
        expect(result.reason).to be_nil
      end

      it 'adds the next TCC two calendar to the orientation' do
        described_class.call(orientation)
        orientation.reload
        expect(orientation.calendars).to include(current_tcc_one, next_tcc_two)
      end

      it 'does not migrate twice' do
        described_class.call(orientation)
        create(:calendar, year: '2026', semester: 'two', tcc: :two,
                          start_date: Date.new(2026, 7, 1), end_date: Date.new(2026, 12, 31))
        result = described_class.call(orientation.reload)

        expect(result.migrated).to be(false)
        expect(result.reason).to eq(:already_migrated)
      end

      it 'returns not migrated when the orientation update fails' do
        allow(orientation).to receive(:update).and_return(false)

        result = described_class.call(orientation)

        expect(result.migrated).to be(false)
        expect(result.reason).to eq(:update_failed)
      end
    end
  end
end
