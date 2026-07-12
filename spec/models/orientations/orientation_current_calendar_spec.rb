require 'rails_helper'

RSpec.describe Orientation do
  describe '#current_calendar' do
    it 'returns the tcc two calendar' do
      calendar_one = find_or_create_calendar(
        year: Calendar.current_year,
        semester: Calendar.current_semester - 1,
        tcc: Calendar.tccs[:one]
      )
      calendar_two = find_or_create_calendar(
        year: Calendar.current_year,
        semester: Calendar.current_semester,
        tcc: Calendar.tccs[:two]
      )

      orientation = create(:orientation, calendar_ids: [calendar_two.id, calendar_one.id])

      expect(orientation.current_calendar).to eq(calendar_two)
    end

    it 'returns the tcc two calendar when two calendars in same semester' do
      calendar_one = find_or_create_calendar(
        year: Calendar.current_year,
        semester: Calendar.current_semester,
        tcc: Calendar.tccs[:one]
      )
      calendar_two = find_or_create_calendar(
        year: Calendar.current_year,
        semester: Calendar.current_semester,
        tcc: Calendar.tccs[:two]
      )

      orientation = create(:orientation, calendar_ids: [calendar_two.id, calendar_one.id])

      expect(orientation.current_calendar).to eq(calendar_two)
    end
  end
end
