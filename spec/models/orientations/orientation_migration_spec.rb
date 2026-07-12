require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe '#to_migrate' do
    before do
      travel_to Date.new(2025, 5, 15)
      OrientationCalendar.delete_all
      described_class.delete_all
      Calendar.delete_all
    end

    let!(:valid_orientation) do
      create(
        :orientation,
        :tcc_one,
        :approved_tcc_one,
        :with_final_project,
        :with_extra_supervisors
      )
    end
    let!(:valid_orientation_two) do
      create(:orientation, :tcc_one, :current, :approved_tcc_one, :with_final_project)
    end
    let!(:invalid_orientation) do
      create(:orientation, :tcc_one, :next, :approved_tcc_one, :with_final_project)
    end
    let!(:invalid_orientation_two) { create(:orientation, :approved) }
    let!(:invalid_orientation_three) { create(:orientation, :canceled) }

    it 'returns the orientations that can be migrated' do
      current_cal = find_or_create_calendar(year: 2025, semester: 1, tcc: Calendar.tccs[:one])
      find_or_create_calendar(year: 2025, semester: 2, tcc: Calendar.tccs[:one])
      create(:orientation, calendars: [current_cal])

      expect(described_class.to_migrate.count).to eq(2)
      expect(described_class.to_migrate).to contain_exactly(
        valid_orientation,
        valid_orientation_two
      )
    end

    it 'do not returns the orientations that can not be migrated' do
      expect(described_class.to_migrate)
        .not_to include([invalid_orientation, invalid_orientation_two, invalid_orientation_three])
    end
  end

  describe '#migrate' do
    before do
      Calendar.delete_all
      described_class.delete_all
      OrientationCalendar.delete_all
    end

    context 'when calendar for next semester is not found' do
      it 'does not migrate' do
        temp_current = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:two]
        )
        orientation = create(:orientation, calendars: [temp_current])

        expect(orientation.migrate).to be(false)
        expect(orientation.calendars.count).to eq(1)
      end
    end

    context 'when calendar for next semester is found' do
      before do
        travel_to Date.new(2025, 8, 1)
        DocumentType.find_or_create_by!(identifier: :tco, name: 'TCO Test')
        DocumentType.find_or_create_by!(identifier: :tcai, name: 'TCAI Test')
      end

      let!(:current_calendar_second_semester_tcc_one) do
        create(
          :calendar, year: '2025', semester: 'two', tcc: :one,
                     start_date: Date.new(2025, 7, 1),
                     end_date: Date.new(2025, 12, 31)
        )
      end

      let!(:next_year_calendar_first_semester_tcc_two) do
        create(
          :calendar, year: '2026', semester: 'one', tcc: :two,
                     start_date: Date.new(2026, 1, 1),
                     end_date: Date.new(2026, 6, 30)
        )
      end

      let!(:current_calendar_tcc_one) do
        create(
          :calendar, year: '2025', semester: 'one', tcc: Calendar.tccs[:one],
                     start_date: Date.new(2025, 1, 1),
                     end_date: Date.new(2025, 6, 30)
        )
      end

      let!(:current_calendar_tcc_two) do
        find_or_create_calendar(year: 2025, semester: 1, tcc: Calendar.tccs[:two])
      end

      let!(:next_calendar_tcc_two) do
        create(
          :calendar, year: '2025', semester: 'two', tcc: Calendar.tccs[:two],
                     start_date: Date.new(2025, 7, 1), end_date: Date.new(2025, 12, 31)
        )
      end

      it 'migrates TCC one orientation to the next semester' do
        orientation = create(
          :orientation,
          :tcc_one,
          :approved_tcc_one,
          :with_final_project,
          :with_extra_supervisors,
          calendars: [current_calendar_second_semester_tcc_one]
        )

        expect(orientation.migrate).to be(true)
        orientation.reload

        expect(orientation.calendars).to include(
          current_calendar_second_semester_tcc_one,
          next_year_calendar_first_semester_tcc_two
        )
        expect(orientation.current_calendar).to eq(next_year_calendar_first_semester_tcc_two)
      end

      it 'changes migrated TCC one orientation to TCC two' do
        orientation = create(
          :orientation,
          :tcc_one,
          :approved_tcc_one,
          :with_final_project,
          :with_extra_supervisors,
          calendars: [current_calendar_second_semester_tcc_one]
        )

        orientation.migrate
        orientation.reload

        expect(orientation.tcc_two?).to be(true)
      end

      it 'migrates TCC two orientation to the next semester' do
        orientation_tcc_two = create(
          :orientation, calendars: [current_calendar_tcc_two],
                        status: 'APPROVED_TCC_ONE'
        )
        orientation_tcc_two.migrate
        orientation_tcc_two.reload

        expect(orientation_tcc_two.calendars).to include(
          current_calendar_tcc_two,
          next_calendar_tcc_two
        )
        expect(orientation_tcc_two.current_calendar).to eq(next_calendar_tcc_two)
      end

      it 'keeps source calendar and adds destination calendar after migration' do
        orientation = create(
          :orientation,
          :tcc_one,
          :approved_tcc_one,
          :with_final_project,
          :with_extra_supervisors,
          calendars: [current_calendar_tcc_one]
        )

        initial_calendar_id = orientation.current_calendar.id
        expect(orientation.migrate).to be(true)
        orientation.reload

        destination_calendar = orientation.calendars.where.not(id: initial_calendar_id).first
        expect(destination_calendar).not_to be_nil
        expect(orientation.calendars.pluck(:id)).to include(initial_calendar_id)
      end

      it 'does not migrate twice' do
        orientation = create(
          :orientation,
          :tcc_one,
          :approved_tcc_one,
          :with_final_project,
          :with_extra_supervisors,
          calendars: [current_calendar_second_semester_tcc_one]
        )

        orientation.migrate
        expect(orientation.migrate).to be(false)
      end
    end

    context 'when orientation is not approved TCC one' do
      it 'does not migrate' do
        orientation = create(:orientation) # status default não é APPROVED_TCC_ONE
        expect(orientation.migrate).to be(false)
        expect(orientation.calendars.count).to eq(1)
      end
    end
  end
end
