require 'rails_helper'

RSpec.describe Orientations::ResponsibleListQuery do
  describe '.call' do
    let(:calendar_years) { (2101..).each }

    def query(tcc: :one, page: nil, term: nil, status: nil)
      described_class.call(tcc:, page:, term:, status:)
    end

    def create_calendar(tcc)
      create(:calendar, tcc:, year: calendar_years.next.to_s)
    end

    it 'returns only orientations exclusive to TCC one' do
      tcc_one_orientation = create(:orientation, calendars: [create_calendar(:one)])
      advanced_orientation = create(
        :orientation,
        calendars: [create_calendar(:one), create_calendar(:two)]
      )
      create(:orientation, calendars: [create_calendar(:two)])

      expect(query(tcc: :one)).to contain_exactly(tcc_one_orientation)
      expect(query(tcc: :one)).not_to include(advanced_orientation)
    end

    it 'returns orientations that have at least one TCC two calendar' do
      create(:orientation, calendars: [create_calendar(:one)])
      advanced_orientation = create(
        :orientation,
        calendars: [create_calendar(:one), create_calendar(:two)]
      )
      tcc_two_orientation = create(:orientation, calendars: [create_calendar(:two)])

      expect(query(tcc: :two)).to contain_exactly(advanced_orientation, tcc_two_orientation)
    end

    it 'does not duplicate orientations with more than one TCC two calendar' do
      advanced_orientation = create(
        :orientation,
        calendars: [
          create_calendar(:one),
          create_calendar(:two),
          create_calendar(:two)
        ]
      )

      expect(query(tcc: :two).pluck(:id)).to eq([advanced_orientation.id])
    end

    it 'restricts the result when status is present' do
      approved_orientation = create(
        :orientation,
        :approved,
        calendars: [create_calendar(:one)]
      )
      create(:orientation, :canceled, calendars: [create_calendar(:one)])

      result = query(tcc: :one, status: Orientation.statuses.key('APPROVED'))

      expect(result).to contain_exactly(approved_orientation)
    end

    it 'applies the textual search supported by Orientation.search' do
      orientation = create(:orientation, calendars: [create_calendar(:one)])
      create(
        :orientation,
        title: 'Outro projeto exclusivo',
        calendars: [create_calendar(:one)]
      )

      expect(query(tcc: :one, term: orientation.academic.name)).to contain_exactly(orientation)
    end

    it 'orders orientations by creation date descending' do
      older_orientation = create(
        :orientation,
        calendars: [create_calendar(:one)],
        created_at: 2.days.ago
      )
      newer_orientation = create(
        :orientation,
        calendars: [create_calendar(:one)],
        created_at: 1.day.ago
      )

      expect(query(tcc: :one).pluck(:id)).to eq([newer_orientation.id, older_orientation.id])
    end

    it 'preserves the paginated relation and record order' do
      default_per_page = Kaminari.config.default_per_page
      Kaminari.config.default_per_page = 2

      oldest_orientation = create(
        :orientation,
        calendars: [create_calendar(:one)],
        created_at: 3.days.ago
      )
      newer_orientation = create(
        :orientation,
        calendars: [create_calendar(:one)],
        created_at: 1.day.ago
      )
      middle_orientation = create(
        :orientation,
        calendars: [create_calendar(:one)],
        created_at: 2.days.ago
      )

      result = query(tcc: :one, page: 2)

      expect(result.current_page).to eq(2)
      expect(result.pluck(:id)).to eq([oldest_orientation.id])
      expect(query(tcc: :one, page: 1).pluck(:id)).to eq(
        [newer_orientation.id, middle_orientation.id]
      )
    ensure
      Kaminari.config.default_per_page = default_per_page
    end

    it 'raises an explicit error when TCC value is invalid' do
      expect do
        query(tcc: :three).to_a
      end.to raise_error(ArgumentError, 'Invalid TCC value: :three')
    end
  end
end
