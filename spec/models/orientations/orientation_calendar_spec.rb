require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe '#calendar_tcc_one?' do
    it 'returns if the calendar orientation is the tcc one?' do
      orientation = create(:orientation, :tcc_one)
      expect(orientation.calendar_tcc_one?).to be(true)
    end
  end

  describe '#calendar_tcc_two?' do
    it 'returns if the calendar orientation is the tcc two?' do
      orientation = create(:orientation, :tcc_two)
      expect(orientation.calendar_tcc_two?).to be(true)
    end
  end

  describe '#by_tcc' do
    let!(:tcc_one_orientations) { create_list(:orientation, 5, :tcc_one) }
    let!(:tcc_two_orientations) { create_list(:orientation, 5, :tcc_two) }

    it 'returns the orientations by tcc one' do
      tcc_one_orientations_found = described_class.by_tcc_one(1, '', 'IN_PROGRESS')

      expect(tcc_one_orientations_found.count).to eq(tcc_one_orientations.count)
      expect(tcc_one_orientations_found).to match_array(tcc_one_orientations)
    end

    it 'returns the orientations by tcc two' do
      tcc_two_orientations_found = described_class.by_tcc_two(1, '', 'IN_PROGRESS')

      expect(tcc_two_orientations_found.count).to eq(tcc_two_orientations.count)
      expect(tcc_two_orientations_found).to match_array(tcc_two_orientations)
    end
  end

  describe '#by_current_tcc' do
    let!(:current_tcc_one_orientation) { create(:orientation, :current, :tcc_one) }
    let!(:current_tcc_two_orientation) { create(:orientation, :current, :tcc_two) }

    it 'returns the current orientations by tcc one' do
      current_tcc_one_orientations_found = described_class.by_current_tcc_one(1, '')

      expect(current_tcc_one_orientations_found.count).to eq(1)
      expect(current_tcc_one_orientations_found).to match_array(current_tcc_one_orientation)
    end

    it 'returns the current orientations by tcc two' do
      current_tcc_two_orientations_found = described_class.by_current_tcc_two(1, '')

      expect(current_tcc_two_orientations_found.count).to eq(1)
      expect(current_tcc_two_orientations_found).to match_array(current_tcc_two_orientation)
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
