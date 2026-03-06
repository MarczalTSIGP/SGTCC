require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:orientation_calendars).dependent(:destroy) }
    it { is_expected.to have_many(:calendars).through(:orientation_calendars) }
    it { is_expected.to belong_to(:academic) }
    it { is_expected.to belong_to(:advisor).class_name('Professor') }
    it { is_expected.to belong_to(:institution).optional }
    it { is_expected.to have_many(:signatures).dependent(:destroy) }
    it { is_expected.to have_many(:documents).through(:signatures) }
    it { is_expected.to have_many(:academic_activities).through(:academic) }
    it { is_expected.to have_many(:meetings).dependent(:destroy) }
    it { is_expected.to have_many(:examination_boards).dependent(:destroy) }
    it { is_expected.to have_many(:orientation_supervisors).dependent(:delete_all) }

    it 'is expected to have many professor supervisors' do
      expect(orientation).to have_many(:professor_supervisors).through(:orientation_supervisors)
                                                              .dependent(:destroy)
    end

    it 'is expected to have many external member supervisors' do
      expect(orientation).to have_many(:external_member_supervisors)
                               .through(:orientation_supervisors).dependent(:destroy)
    end
  end

  describe '#short_title' do
    it 'returns the short title' do
      title = 'title' * 40
      orientation = create(:orientation, title:)
      expect(orientation.short_title).to eq("#{title[0..35]}...")
    end

    it 'returns the title' do
      title = 'title'
      orientation = create(:orientation, title:)
      expect(orientation.short_title).to eq(title)
    end
  end

  describe '#select_status_data' do
    it 'returns the select status data' do
      status_data = described_class.statuses.map do |index, field|
        [ field, index.capitalize ]
      end.sort!
      expect(described_class.select_status_data).to eq(status_data)
    end
  end

  describe '#supervisors' do
    let!(:orientation) { create(:orientation) }
    let!(:professor) { create(:professor) }
    let!(:external_member) { create(:external_member) }

    before do
      professor.supervisions << orientation
      external_member.supervisions << orientation
    end

    it 'returns the supervisors' do
      supervisors = orientation.professor_supervisors + orientation.external_member_supervisors
      expect(orientation.supervisors).to eq(supervisors)
    end
  end

  describe '#equal_status?' do
    it 'returns if the orientation is equal status?' do
      orientation = create(:orientation)
      expect(orientation.equal_status?('IN_PROGRESS')).to be(true)
    end
  end

  describe '#approved?' do
    it 'returns if the orientation is approved?' do
      orientation = create(:orientation_approved)
      expect(orientation.approved?).to be(true)
    end
  end

  describe '#canceled?' do
    it 'returns if the orientation is canceled?' do
      orientation = create(:orientation_canceled)
      expect(orientation.canceled?).to be(true)
    end
  end

  describe '#in_progress?' do
    it 'returns if the orientation is in progress?' do
      orientation = create(:orientation)
      expect(orientation.in_progress?).to be(true)
    end
  end

  describe '#calendar_tcc_one?' do
    it 'returns if the calendar orientation is the tcc one?' do
      orientation = create(:orientation_tcc_one)
      expect(orientation.calendar_tcc_one?).to be(true)
    end
  end

  describe '#calendar_tcc_two?' do
    it 'returns if the calendar orientation is the tcc two?' do
      orientation = create(:orientation_tcc_two)
      expect(orientation.calendar_tcc_two?).to be(true)
    end
  end

  describe '#can_be_canceled?' do
    it 'returns true' do
      professor = create(:responsible)
      orientation = create(:orientation_tcc_two)
      expect(orientation.can_be_canceled?(professor)).to be(true)
    end
  end

  describe '#by_tcc' do
    let!(:tcc_one_orientations) { create_list(:orientation_tcc_one, 5) }
    let!(:tcc_two_orientations) { create_list(:orientation_tcc_two, 5) }

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

  describe '#to_migrate' do
    let!(:valid_orientation) { create(:orientation_tcc_one_approved) }
    let!(:valid_orientation_two) { create(:orientation_tcc_one_approved_current_calendar) }
    let!(:invalid_orientation) { create(:orientation_tcc_one_approved_next_calendar) }
    let!(:invalid_orientation_two) { create(:orientation_approved) }
    let!(:invalid_orientation_three) { create(:orientation_canceled) }

    it 'returns the orientations that can be migrated' do
      current_cal = find_or_create_calendar(year: 2025, semester: 1, tcc: Calendar.tccs[:one])
      find_or_create_calendar(year: 2025, semester: 2, tcc: Calendar.tccs[:one])
      create(:orientation, calendars: [ current_cal ])

      expect(described_class.to_migrate.count).to eq(2)
      expect(described_class.to_migrate).to contain_exactly(valid_orientation,
                                                            valid_orientation_two)
    end

    it 'do not returns the orientations that can not be migrated' do
      expect(described_class.to_migrate)
        .not_to include([ invalid_orientation, invalid_orientation_two, invalid_orientation_three ])
    end
  end

  describe '#migrate' do
    before do
      Calendar.delete_all
      Orientation.delete_all
      OrientationCalendar.delete_all
    end

    context 'when calendar for next semester is not found' do
      it 'does not migrate' do
        temp_current = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:two]
        )
        orientation = create(:orientation, calendars: [ temp_current ])

        expect(orientation.migrate).to be(false)
        expect(orientation.calendars.count).to eq(1)
      end
    end

    context 'when calendar for next semester is found' do
      before do
        travel_to Date.new(2025, 8, 1)
      end

      after do
        travel_back
      end

      let!(:current_calendar_s2_tcc1) do
        create(:calendar, year: '2025', semester: 'two', tcc: :one, start_date: Date.new(2025, 7, 1),
               end_date: Date.new(2025, 12, 31))
      end

      let!(:next_year_calendar_s1_tcc2) do
        create(:calendar, year: '2026', semester: 'one', tcc: :two, start_date: Date.new(2026, 1, 1),
               end_date: Date.new(2026, 6, 30))
      end

      let!(:current_calendar_tcc_one) do
        create(:calendar, year: '2025', semester: 'one', tcc: Calendar.tccs[:one],
               start_date: Date.new(2025, 1, 1), end_date: Date.new(2025, 6, 30))
      end

      let!(:current_calendar_tcc_two) do
        find_or_create_calendar(year: 2025, semester: 1, tcc: Calendar.tccs[:two])
      end

      let!(:next_calendar_tcc_two) do
        create(:calendar, year: '2025', semester: 'two', tcc: Calendar.tccs[:two],
               start_date: Date.new(2025, 7, 1), end_date: Date.new(2025, 12, 31))
      end

      before do
        DocumentType.find_or_create_by!(identifier: :tco, name: 'TCO Test')
        DocumentType.find_or_create_by!(identifier: :tcai, name: 'TCAI Test')
      end

      it 'migrates TCC one orientation to the next semester' do
        orientation = create(:orientation_tcc_one_approved, calendars: [ current_calendar_s2_tcc1 ])

        expect(orientation.migrate).to be(true)
        orientation.reload

        expect(orientation.calendars).to include(current_calendar_s2_tcc1,
                                                 next_year_calendar_s1_tcc2)
        expect(orientation.current_calendar).to eq(next_year_calendar_s1_tcc2)
      end

      it 'changes migrated TCC one orientation to TCC two' do
        orientation = create(:orientation_tcc_one_approved, calendars: [ current_calendar_s2_tcc1 ])

        orientation.migrate
        orientation.reload

        expect(orientation.tcc_two?).to be(true)
      end

      it 'migrates TCC two orientation to the next semester' do
        orientation_tcc_two = create(:orientation, calendars: [ current_calendar_tcc_two ], status: 'APPROVED_TCC_ONE')
        orientation_tcc_two.migrate
        orientation_tcc_two.reload

        expect(orientation_tcc_two.calendars).to include(current_calendar_tcc_two,
                                                         next_calendar_tcc_two)
        expect(orientation_tcc_two.current_calendar).to eq(next_calendar_tcc_two)
      end

      it 'keeps source calendar and adds destination calendar after migration' do
        orientation = create(:orientation_tcc_one_approved, calendars: [ current_calendar_tcc_one ])

        initial_calendar_id = orientation.current_calendar.id
        expect(orientation.migrate).to be(true)
        orientation.reload

        destination_calendar = orientation.calendars.where.not(id: initial_calendar_id).first
        expect(destination_calendar).not_to be_nil
        expect(orientation.calendars.pluck(:id)).to include(initial_calendar_id)
      end

      it 'does not migrate twice' do
        orientation = create(:orientation_tcc_one_approved, calendars: [ current_calendar_tcc_one ])

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

  describe '#by_current_tcc' do
    let!(:current_tcc_one_orientation) { create(:current_orientation_tcc_one) }
    let!(:current_tcc_two_orientation) { create(:current_orientation_tcc_two) }

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

  describe '#cancel' do
    context 'when the orientation is cancelled' do
      let(:orientation) { create(:orientation) }

      it 'is status equal cancelled' do
        orientation.cancel('Justification')
        orientation.reload
        expect(orientation.status).to eq('cancelada')
      end
    end
  end

  describe '#professor_supervisors_to_document' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.professor_supervisors.first }

    it 'returns the array with professor supervisors name formatted' do
      formatted = [ { id: professor.id,
                      name: "#{professor.scholarity.abbr} #{professor.name}" } ]
      expect(orientation.professor_supervisors_to_document).to match_array(formatted)
    end
  end

  describe '#external_member_supervisors_to_document' do
    let(:orientation) { create(:orientation) }
    let(:external_member) { orientation.external_member_supervisors.first }

    it 'returns the array with professor supervisors name formatted' do
      formatted = [ { id: external_member.id,
                      name: "#{external_member.scholarity.abbr} #{external_member.name}" } ]
      expect(orientation.external_member_supervisors_to_document).to match_array(formatted)
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

  describe '#professors_ranking' do
    let!(:professor_orientations) { create_list(:orientation_tcc_two_approved, 4) }
    let!(:professors) { professor_orientations.map(&:advisor) }

    it 'returns the professors ranking data' do
      ranking = professors.map do |professor|
        [ professor.name_with_scholarity, professor.orientations.size ]
      end
      ranking = ranking.sort_by { |professor| professor[1] }.reverse
      expect(described_class.professors_ranking).to match_array(ranking)
    end
  end

  describe '#to_json_table' do
    let(:orientations) { create_list(:orientation, 2) }
    let(:orientation_methods) do
      [ :short_title, :final_proposal, :final_project, :final_monograph,
        :document_title, :document_summary ]
    end

    let(:orientations_json) do
      orientations.to_json(methods: orientation_methods,
                           include: [ :academic,
                                      { supervisors: { methods: [ :name_with_scholarity ] } },
                                      { advisor: { methods: [ :name_with_scholarity ] } } ])
    end

    it 'returns the orientation to json table' do
      expect(described_class.to_json_table(orientations)).to eq(orientations_json)
    end
  end

  describe 'academic activities documents' do
    # Simulates a orientation with two tcc two calendars
    # and sends files in both.
    # Must consider the last one the correct.
    describe '.proposal' do
      let(:previous_calendar) { create(:previous_calendar_tcc_one) }
      let(:current_calendar) { create(:current_calendar_tcc_one) }

      let(:orientation) { create(:orientation_tcc_one) }
      let(:orientation_two) { create(:orientation_tcc_one) }
      let!(:academic_activity_two) do
        activity_two = create(:proposal_activity, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [ previous_calendar, current_calendar ]
        activity_one = create(:project_activity, calendar: previous_calendar)
        create(:academic_activity, activity: activity_one, academic: orientation.academic)
      end

      it 'returns the proposal document' do
        expect(orientation.proposal).to eq(academic_activity_two)
        expect(orientation_two.proposal).to be_nil
      end

      it 'returns the final version of proposal document' do
        academic_activity_two.activity.update(final_version: true)

        expect(orientation.final_proposal).to eq(academic_activity_two)
        expect(orientation_two.proposal).to be_nil
      end
    end

    describe '.project' do
      let(:previous_calendar) { create(:previous_calendar_tcc_one) }
      let(:current_calendar) { create(:current_calendar_tcc_one) }

      let(:orientation) { create(:orientation_tcc_one) }
      let!(:academic_activity_two) do
        activity_two = create(:project_activity, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [ previous_calendar, current_calendar ]
        activity_one = create(:project_activity, calendar: previous_calendar)
        create(:academic_activity, activity: activity_one, academic: orientation.academic)
      end

      it 'returns the project document' do
        expect(orientation.project).to eq(academic_activity_two)
      end

      it 'returns the final version of project document' do
        academic_activity_two.activity.update(final_version: true)
        expect(orientation.final_project).to eq(academic_activity_two)
      end
    end

    describe '.monograph' do
      let(:previous_calendar) { create(:previous_calendar_tcc_two) }
      let(:current_calendar) { create(:current_calendar_tcc_two) }

      let(:orientation) { create(:orientation_tcc_two) }
      let!(:academic_activity) do
        activity_two = create(:monograph_activity, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [ previous_calendar, current_calendar ]
        activity_one = create(:monograph_activity, calendar: previous_calendar)
        create(:academic_activity, activity: activity_one, academic: orientation.academic)
      end

      it 'returns the monograph document' do
        expect(orientation.monograph).to eq(academic_activity)
      end

      it 'returns the final version of monograph document' do
        academic_activity.activity.update(final_version: true)
        expect(orientation.final_monograph).to eq(academic_activity)
      end
    end
  end

  describe '.document_tcc_one' do
    it 'returns the document tcc one' do
      orientation = create(:orientation_tcc_one)
      document = create(:proposal_academic_activity, academic: orientation.academic)
      orientation.calendars = [ document.activity.calendar ]

      expect(orientation.document_tcc_one).to eq(document)
    end
  end

  describe '#by_status' do
    before do
      create(:orientation) # IN_PROGRESS
      create(:orientation_tcc_one_approved)
      create(:orientation_tcc_two_approved)
      create(:orientation_canceled)
    end

    it 'return in progress orientations' do
      expect(described_class.in_tcc_one.count).to eq(1)
    end

    it 'return approved in tcc one orientations' do
      expect(described_class.approved_tcc_one.count).to eq(1)
    end

    it 'return approved orientations' do
      expect(described_class.approved.count).to eq(1)
    end
  end

  describe '#cs_asc_from_now_desc_ago' do
    it 'returns just current semester examination boards asc order from now desc order for past' do
      current_calendar = create(:calendar_tcc_one,
                                start_date: 1.year.ago,
                                end_date: 1.year.from_now)

      create(:orientation, calendars: [ current_calendar ])

      previous_calendar = create(:previous_calendar_tcc_one)

      examination_board_one = create(:examination_board,
                                     date: 2.hours.from_now,
                                     orientation: create(:orientation,
                                                         calendars: [ current_calendar ]))

      examination_board_two = create(:examination_board,
                                     date: 1.day.from_now,
                                     orientation: create(:orientation,
                                                         calendars: [ current_calendar ]))

      examination_board_three = create(:examination_board,
                                       date: 1.day.ago,
                                       orientation: create(:orientation,
                                                           calendars: [ current_calendar ]))

      create(:examination_board, date: 6.months.ago,
             orientation: create(:orientation, calendars: [ previous_calendar ]))

      create(:examination_board, date: 1.year.ago,
             orientation: create(:orientation, calendars: [ previous_calendar ]))

      result = ExaminationBoard.cs_asc_from_now_desc_ago

      expected_result = [
        examination_board_one,
        examination_board_two,
        examination_board_three
      ]

      expect(result.map(&:id)).to eq(expected_result.map(&:id))
    end
  end
end
