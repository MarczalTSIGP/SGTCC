require 'rails_helper'

RSpec.describe Orientation, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:calendar) }
    it { is_expected.to belong_to(:academic) }
    it { is_expected.to belong_to(:advisor).class_name('Professor') }
    it { is_expected.to belong_to(:institution) }
    it { is_expected.to have_many(:signatures).dependent(:destroy) }
    it { is_expected.to have_many(:documents).through(:signatures) }
    it { is_expected.to have_many(:meetings).dependent(:destroy) }
    it { is_expected.to have_many(:examination_boards).dependent(:destroy) }
    it { is_expected.to have_many(:orientation_supervisors).dependent(:delete_all) }

    it 'is expected to have many professor supervisors' do
      is_expected.to have_many(:professor_supervisors).through(:orientation_supervisors)
                                                      .dependent(:destroy)
    end

    it 'is expected to have many external member supervisors' do
      is_expected.to have_many(:external_member_supervisors).through(:orientation_supervisors)
                                                            .dependent(:destroy)
    end
  end

  describe '#short_title' do
    it 'returns the short title' do
      title = 'title' * 40
      orientation = create(:orientation, title: title)
      expect(orientation.short_title).to eq("#{title[0..35]}...")
    end

    it 'returns the title' do
      title = 'title'
      orientation = create(:orientation, title: title)
      expect(orientation.short_title).to eq(title)
    end
  end

  describe '#select_status_data' do
    it 'returns the select status data' do
      status_data = Orientation.statuses.map do |index, field|
        [field, index.capitalize]
      end.sort!
      expect(Orientation.select_status_data).to eq(status_data)
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
      expect(orientation.equal_status?('IN_PROGRESS')).to eq(true)
    end
  end

  describe '#renewed?' do
    it 'returns if the orientation is renewed?' do
      orientation = create(:orientation_renewed)
      expect(orientation.renewed?).to eq(true)
    end
  end

  describe '#approved?' do
    it 'returns if the orientation is approved?' do
      orientation = create(:orientation_approved)
      expect(orientation.approved?).to eq(true)
    end
  end

  describe '#canceled?' do
    it 'returns if the orientation is canceled?' do
      orientation = create(:orientation_canceled)
      expect(orientation.canceled?).to eq(true)
    end
  end

  describe '#in_progress?' do
    it 'returns if the orientation is in progress?' do
      orientation = create(:orientation)
      expect(orientation.in_progress?).to eq(true)
    end
  end

  describe '#calendar_tcc_one?' do
    it 'returns if the calendar orientation is the tcc one?' do
      orientation = create(:orientation_tcc_one)
      expect(orientation.calendar_tcc_one?).to eq(true)
    end
  end

  describe '#calendar_tcc_two?' do
    it 'returns if the calendar orientation is the tcc two?' do
      orientation = create(:orientation_tcc_two)
      expect(orientation.calendar_tcc_two?).to eq(true)
    end
  end

  describe '#can_be_renewed?' do
    it 'returns true' do
      professor = create(:responsible)
      orientation = create(:orientation_tcc_two)
      expect(orientation.can_be_renewed?(professor)).to eq(true)
    end

    it 'returns false' do
      professor = create(:professor)
      orientation = create(:orientation_tcc_one)
      expect(orientation.can_be_renewed?(professor)).to eq(false)
    end
  end

  describe '#can_be_canceled?' do
    it 'returns true' do
      professor = create(:responsible)
      orientation = create(:orientation_tcc_two)
      expect(orientation.can_be_canceled?(professor)).to eq(true)
    end

    it 'returns false' do
      professor = create(:responsible)
      orientation = create(:orientation_canceled)
      expect(orientation.can_be_renewed?(professor)).to eq(false)
    end
  end

  describe '#can_be_edited?' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    it 'returns true' do
      expect(orientation.can_be_edited?).to eq(true)
    end

    context 'when cant be edited' do
      before do
        orientation.signatures.each(&:sign)
      end

      it 'returns false' do
        expect(orientation.can_be_edited?).to eq(false)
      end
    end
  end

  describe '#can_be_destroyed?' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    it 'returns true' do
      expect(orientation.can_be_destroyed?).to eq(true)
    end

    context 'when returns false' do
      before do
        orientation.signatures.each(&:sign)
      end

      it 'returns false' do
        expect(orientation.can_be_destroyed?).to eq(false)
      end
    end
  end

  describe '#by_tcc' do
    before do
      create_list(:orientation, 5)
    end

    it 'returns the orientations by tcc one' do
      orientations_tcc_one = Orientation.joins(:calendar)
                                        .where(calendars: { tcc: Calendar.tccs[:one] })
                                        .page(1)
      expect(Orientation.by_tcc_one(1, '', 'IN_PROGRESS')).to match_array(orientations_tcc_one)
    end

    it 'returns the orientations by tcc two' do
      orientations_tcc_two = Orientation.joins(:calendar)
                                        .where(calendars: { tcc: Calendar.tccs[:two] })
                                        .page(1)
      expect(Orientation.by_tcc_two(1, '')).to match_array(orientations_tcc_two)
    end
  end

  describe '#by_current_tcc' do
    before do
      create(:current_orientation_tcc_one)
      create(:current_orientation_tcc_two)
    end

    it 'returns the current orientations by tcc one' do
      query = { tcc: Calendar.tccs[:one],
                year: Calendar.current_year,
                semester: Calendar.current_semester }
      orientations_tcc_one = Orientation.joins(:calendar)
                                        .where(calendars: query)
                                        .page(1)
      expect(Orientation.by_current_tcc_one(1, '')).to match_array(orientations_tcc_one)
    end

    it 'returns the current orientations by tcc two' do
      query = { tcc: Calendar.tccs[:two],
                year: Calendar.current_year,
                semester: Calendar.current_semester }
      orientations_tcc_two = Orientation.joins(:calendar)
                                        .where(calendars: query)
                                        .page(1)
      expect(Orientation.by_current_tcc_two(1, '')).to match_array(orientations_tcc_two)
    end
  end

  describe '#search' do
    let(:orientation) { create(:orientation) }

    context 'when finds orientation by attributes' do
      it 'returns orientation by title' do
        results_search = Orientation.search(orientation.title)
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        results_search = Orientation.search(orientation.academic.name)
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by academic ra' do
        results_search = Orientation.search(orientation.academic.ra)
        expect(orientation.academic.ra).to eq(results_search.first.academic.ra)
      end

      it 'returns orientation by advisor name' do
        results_search = Orientation.search(orientation.advisor.name)
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end

      it 'returns orientation by calendar year' do
        results_search = Orientation.search(orientation.calendar.year)
        expect(orientation.calendar.year).to eq(results_search.first.calendar.year)
      end

      it 'returns orientation by institution name' do
        results_search = Orientation.search(orientation.institution.name)
        expect(orientation.institution.name).to eq(results_search.first.institution.name)
      end

      it 'returns orientation by institution trade name' do
        trade_name = orientation.institution.trade_name
        results_search = Orientation.search(trade_name)
        expect(trade_name).to eq(results_search.first.institution.trade_name)
      end
    end

    context 'when finds orientation with accents' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema de Gestão')
        results_search = Orientation.search('Sistema de Gestao')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'João')
        orientation = create(:orientation, academic: academic)
        results_search = Orientation.search(academic.name)
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Júlio')
        orientation = create(:orientation, advisor: advisor)
        results_search = Orientation.search(advisor.name)
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end

    context 'when finds orientation on search term with accents' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema de Gestao')
        results_search = Orientation.search('Sistema de Gestão')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'Joao')
        orientation = create(:orientation, academic: academic)
        results_search = Orientation.search('João')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Julio')
        orientation = create(:orientation, advisor: advisor)
        results_search = Orientation.search('Júlio')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end

    context 'when finds orientation ignoring the case sensitive' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema')
        results_search = Orientation.search('sistema')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by title on search term' do
        orientation = create(:orientation, title: 'sistema')
        results_search = Orientation.search('SISTEMA')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'Joao')
        orientation = create(:orientation, academic: academic)
        results_search = Orientation.search('joao')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by academic name on search term' do
        academic = create(:academic, name: 'joao')
        orientation = create(:orientation, academic: academic)
        results_search = Orientation.search('JOAO')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Julio')
        orientation = create(:orientation, advisor: advisor)
        results_search = Orientation.search('julio')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end

      it 'returns orientation by advisor name on search term' do
        advisor = create(:professor, name: 'julio')
        orientation = create(:orientation, advisor: advisor)
        results_search = Orientation.search('JULIO')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end
  end

  describe '#renew' do
    context 'when the orientation is renewed' do
      let!(:calendar) { create(:calendar_tcc_two, year: 2019, semester: 1) }
      let!(:next_calendar) { create(:calendar_tcc_two, year: 2019, semester: 2) }
      let!(:orientation) { create(:orientation_renewed, calendar: calendar) }
      let(:new_orientation) { orientation.dup }
      let(:renewed_orientation) do
        orientation.renew(orientation.renewal_justification)
      end

      it 'is equal calendar' do
        new_orientation.calendar = next_calendar
        expect(renewed_orientation.calendar).to eq(new_orientation.calendar)
      end

      it 'is equal title' do
        expect(renewed_orientation.title).to eq(new_orientation.title)
      end

      it 'is equal justification' do
        expect(renewed_orientation.renewal_justification).to eq(
          new_orientation.renewal_justification
        )
      end

      it 'is equal academic' do
        expect(renewed_orientation.academic).to eq(new_orientation.academic)
      end

      it 'is equal advisor' do
        expect(renewed_orientation.advisor).to eq(new_orientation.advisor)
      end
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
      formatted = [{ id: professor.id,
                     name: "#{professor.scholarity.abbr} #{professor.name}" }]
      expect(orientation.professor_supervisors_to_document).to match_array(formatted)
    end
  end

  describe '#external_member_supervisors_to_document' do
    let(:orientation) { create(:orientation) }
    let(:external_member) { orientation.external_member_supervisors.first }

    it 'returns the array with professor supervisors name formatted' do
      formatted = [{ id: external_member.id,
                     name: "#{external_member.scholarity.abbr} #{external_member.name}" }]
      expect(orientation.external_member_supervisors_to_document).to match_array(formatted)
    end
  end

  describe '#after_create' do
    let(:orientation) { create(:orientation) }
    let(:signatures) { orientation.signatures }

    before do
      orientation.signatures << Signature.all
    end

    context 'when is the tco signature' do
      let(:document_tco) { signatures.first.document }
      let(:tco_signatures) { signatures.where(document_id: document_tco.id) }
      let(:academic_signature) { tco_signatures.where(user_type: :academic).first }
      let(:advisor_signature) { tco_signatures.where(user_type: :advisor).first }

      let(:professor_supervisor_signature) do
        tco_signatures.where(user_type: :professor_supervisor).first
      end

      let(:external_member_signature) do
        tco_signatures.where(user_type: :external_member_supervisor).first
      end

      let(:academic) { academic_signature.user }
      let(:advisor) { advisor_signature.user }
      let(:professor_supervisor) { professor_supervisor_signature.user }
      let(:external_member_supervisor) { external_member_signature.user }

      it 'returns the Academic signature' do
        attributes = { user_type: 'academic', user_id: academic.id,
                       status: false, document_id: document_tco.id,
                       orientation_id: orientation.id }
        expect(academic_signature).to have_attributes(attributes)
      end

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document_tco.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Professor Supervisor signature' do
        attributes = { user_type: 'professor_supervisor',
                       user_id: professor_supervisor.id,
                       status: false, document_id: document_tco.id,
                       orientation_id: orientation.id }
        expect(professor_supervisor_signature).to have_attributes(attributes)
      end

      it 'returns the External Member Supervisor signature' do
        attributes = { user_type: 'external_member_supervisor',
                       user_id: external_member_supervisor.id,
                       status: false, document_id: document_tco.id,
                       orientation_id: orientation.id }
        expect(external_member_signature).to have_attributes(attributes)
      end

      it 'returns the signature count' do
        expect(tco_signatures.count).to eq(4)
      end
    end

    context 'when is the tcai signature' do
      let(:document_tcai) { signatures.last.document }
      let(:tcai_signatures) { signatures.where(document_id: document_tcai.id) }
      let(:academic_signature) { tcai_signatures.where(user_type: :academic).first }
      let(:advisor_signature) { tcai_signatures.where(user_type: :advisor).first }

      let(:professor_supervisor_signature) do
        tcai_signatures.where(user_type: :professor_supervisor).first
      end

      let(:external_member_signature) do
        tcai_signatures.where(user_type: :external_member_supervisor).first
      end

      let(:responsible_institution_signature) do
        tcai_signatures.where(user_type: :external_member_supervisor).last
      end

      let(:academic) { academic_signature.user }
      let(:advisor) { advisor_signature.user }
      let(:professor_supervisor) { professor_supervisor_signature.user }
      let(:external_member_supervisor) { external_member_signature.user }
      let(:responsible_institution_supervisor) { responsible_institution_signature.user }

      it 'returns the Academic signature' do
        attributes = { user_type: 'academic', user_id: academic.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(academic_signature).to have_attributes(attributes)
      end

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Professor Supervisor signature' do
        attributes = { user_type: 'professor_supervisor',
                       user_id: professor_supervisor.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(professor_supervisor_signature).to have_attributes(attributes)
      end

      it 'returns the External Member Supervisor signature' do
        attributes = { user_type: 'external_member_supervisor',
                       user_id: external_member_supervisor.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(external_member_signature).to have_attributes(attributes)
      end

      it 'returns the External Member Responsible Institution Supervisor signature' do
        attributes = { user_type: 'external_member_supervisor',
                       user_id: responsible_institution_supervisor.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(responsible_institution_signature).to have_attributes(attributes)
      end

      it 'returns the signature count' do
        expect(tcai_signatures.count).to eq(5)
      end
    end
  end

  describe '#academic_with_calendar' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }
    let(:calendar) { orientation.calendar }

    it 'is equal academic with calendar' do
      academic_with_ra = "#{academic.name} (#{academic.ra})"
      academic_with_calendar = "#{academic_with_ra} | #{calendar.year_with_semester_and_tcc}"
      expect(orientation.academic_with_calendar).to eq(academic_with_calendar)
    end
  end

  describe '#professors_ranking' do
    let!(:professor_orientations) { create_list(:orientation_tcc_two_approved, 4) }
    let!(:professors) { professor_orientations.map(&:advisor) }

    it 'returns the professors ranking data' do
      ranking = professors.map do |professor|
        [professor.name_with_scholarity, professor.orientations.size]
      end
      ranking = ranking.sort_by { |professor| professor[1] }.reverse[0..4]
      expect(Orientation.professors_ranking).to eq(ranking)
    end
  end

  describe '#to_json_table' do
    let(:orientations) { create_list(:orientation, 2) }
    let(:academic_methods) { [:final_proposal, :final_project, :final_monograph] }

    let(:orientations_json) do
      orientations.to_json(methods: [:short_title],
                           include: [:supervisors,
                                     { academic: { methods: academic_methods } },
                                     { advisor: { methods: [:name_with_scholarity] } }])
    end

    it 'returns the orientation to json table' do
      expect(Orientation.to_json_table(orientations)).to eq(orientations_json)
    end
  end
end
