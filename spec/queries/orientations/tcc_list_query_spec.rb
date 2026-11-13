require 'rails_helper'

RSpec.describe Orientations::TccListQuery do
  let(:calendar_years) { (2201..).each }

  def create_calendar(tcc, year: nil)
    create(:calendar, tcc:, year: (year || calendar_years.next).to_s)
  end

  def call(**)
    described_class.call(relation: Orientation.all, tcc: :one, page: nil, term: nil, **)
  end

  describe '.call with tcc: :one' do
    let!(:tcc_one_orientations) { create_list(:orientation, 3, :tcc_one) }
    let!(:tcc_two_orientations) { create_list(:orientation, 2, :tcc_two) }

    it 'returns orientations in TCC one' do
      result = call(tcc: :one, status: 'IN_PROGRESS')
      expect(result).to match_array(tcc_one_orientations)
    end

    it 'does not return TCC two orientations' do
      result = call(tcc: :one, status: 'IN_PROGRESS')
      expect(result).not_to include(*tcc_two_orientations)
    end
  end

  describe '.call with tcc: :two' do
    before { create_list(:orientation, 2, :tcc_one) }

    let!(:tcc_two_orientations) { create_list(:orientation, 3, :tcc_two) }

    it 'returns orientations in TCC two' do
      result = call(tcc: :two, status: 'IN_PROGRESS')
      expect(result).to match_array(tcc_two_orientations)
    end
  end

  describe '.call with period: :current' do
    let!(:current_tcc_one) { create(:orientation, :current, :tcc_one) }
    let!(:current_tcc_two) { create(:orientation, :current, :tcc_two) }

    it 'returns only current semester TCC one orientations' do
      result = call(tcc: :one, period: :current)
      expect(result).to contain_exactly(current_tcc_one)
    end

    it 'returns only current semester TCC two orientations' do
      result = call(tcc: :two, period: :current)
      expect(result).to contain_exactly(current_tcc_two)
    end
  end

  describe '.call with status filter' do
    let!(:in_progress) { create(:orientation, :tcc_one) }
    let!(:approved) { create(:orientation, :tcc_one, :approved_tcc_one) }

    it 'filters by status when provided' do
      result = call(tcc: :one, status: 'IN_PROGRESS')
      expect(result).to include(in_progress)
      expect(result).not_to include(approved)
    end

    it 'returns all statuses when status is blank' do
      result = call(tcc: :one, status: nil)
      expect(result).to include(in_progress, approved)
    end
  end

  describe '.call with a scoped relation' do
    let(:professor) { create(:professor) }
    let!(:professor_orientation) { create(:orientation, :tcc_one, advisor: professor) }
    let!(:other_orientation) { create(:orientation, :tcc_one) }

    it 'applies the relation scope correctly' do
      result = described_class.call(
        relation: professor.orientations,
        tcc: :one,
        page: nil,
        term: nil
      )
      expect(result).to include(professor_orientation)
      expect(result).not_to include(other_orientation)
    end
  end

  describe '.call with term search' do
    let!(:orientation) { create(:orientation, :tcc_one, title: 'Unique Query Title XYZ') }
    let!(:other) { create(:orientation, :tcc_one, title: 'Other Title') }

    it 'filters by term' do
      result = call(tcc: :one, term: 'XYZ', status: 'IN_PROGRESS')
      expect(result).to include(orientation)
      expect(result).not_to include(other)
    end
  end
end
