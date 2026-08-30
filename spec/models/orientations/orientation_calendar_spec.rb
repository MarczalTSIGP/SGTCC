require 'rails_helper'

RSpec.describe Orientation do
  describe '#tcc_one?' do
    it 'returns true when the current calendar is TCC one' do
      orientation = create(:orientation, :tcc_one)
      expect(orientation.tcc_one?).to be(true)
    end
  end

  describe '#tcc_two?' do
    it 'returns true when the current calendar is TCC two' do
      orientation = create(:orientation, :tcc_two)
      expect(orientation.tcc_two?).to be(true)
    end
  end

  describe '#academic_with_calendar' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    it 'is equal academic with calendar' do
      academic_with_ra = "#{academic.name} (#{academic.ra})"
      awc = "#{academic_with_ra} | #{orientation.current_calendar.year_with_semester_and_tcc}"
      expect(orientation.academic_with_calendar).to eq(awc)
    end
  end
end
