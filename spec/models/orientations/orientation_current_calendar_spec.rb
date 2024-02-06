require 'rails_helper'

RSpec.describe Orientation do
  describe '#current_calendar' do
    it 'returns the tcc two calendar' do
      calendar_one = create(:previous_calendar_tcc_one)
      calendar_two = create(:current_calendar_tcc_two)

      orientation = create(:orientation, calendar_ids: [calendar_two.id, calendar_one.id])

      expect(orientation.current_calendar).to eq(calendar_two)
    end

    it 'returns the tcc two calendar when two calendars in same semester' do
      calendar_one = create(:current_calendar_tcc_one)
      calendar_two = create(:current_calendar_tcc_two)

      orientation = create(:orientation, calendar_ids: [calendar_two.id, calendar_one.id])

      expect(orientation.current_calendar).to eq(calendar_two)
    end
  end
end
