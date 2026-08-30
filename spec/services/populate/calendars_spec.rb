require 'rails_helper'

RSpec.describe Populate::Calendars do
  describe '#populate' do
    before { Calendar.delete_all }

    it 'creates calendars in the same tcc order using the enum persisted values' do
      expect { described_class.new.populate }.to change(Calendar, :count).by(8)

      tcc_values = Calendar.order(:created_at).last(8).map do |calendar|
        calendar.read_attribute_before_type_cast(:tcc)
      end
      semester_values = Calendar.order(:created_at).last(8).map do |calendar|
        calendar.read_attribute_before_type_cast(:semester)
      end
      expected_semesters = [
        *([Calendar.current_semester] * 2),
        *([previous_semester(Calendar.current_semester)] * 2),
        *([Calendar.current_semester] * 2),
        *([previous_semester(Calendar.current_semester)] * 2)
      ]

      expect(tcc_values).to eq([2, 1, 2, 1, 2, 1, 2, 1])
      expect(semester_values).to eq(expected_semesters)
    end
  end

  def previous_semester(semester)
    return Calendar.semesters.fetch(:two) if semester == Calendar.semesters.fetch(:one)

    Calendar.semesters.fetch(:one)
  end
end
