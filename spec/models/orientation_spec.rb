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

  describe '#signatures_mark' do
    let!(:professor) { create(:professor) }
    let!(:supervisor) { create(:professor) }
    let!(:academic) { create(:academic) }
    let!(:external_member) { create(:external_member) }
    let!(:orientation) { create(:orientation, advisor: professor, academic: academic) }
    let!(:signature_signed) do
      create(:signature_signed, orientation_id: orientation.id, user_id: professor.id)
    end

    let!(:academic_signature_signed) do
      create(:academic_signature_signed, orientation_id: orientation.id, user_id: academic.id)
    end

    let!(:external_member_signature_signed) do
      create(:external_member_signature_signed, orientation_id: orientation.id,
                                                user_id: external_member.id)
    end

    let!(:professor_signature_signed) do
      create(:signature_signed, orientation_id: orientation.id, user_id: supervisor.id)
    end

    let(:roles) do
      'signatures.users.roles'
    end

    let(:supervisor_role) do
      I18n.t("#{roles}.#{supervisor.gender}.#{professor_signature_signed.user_type}")
    end

    let(:external_member_role) do
      I18n.t("#{roles}.#{external_member.gender}.#{external_member_signature_signed.user_type}")
    end

    let(:academic_role) do
      I18n.t("#{roles}.#{academic.gender}.#{academic_signature_signed.user_type}")
    end

    let(:professor_role) do
      I18n.t("#{roles}.#{professor.gender}.#{signature_signed.user_type}")
    end

    before do
      orientation.external_member_supervisors << external_member
      orientation.professor_supervisors << supervisor
    end

    it 'returns the signatures mark' do
      signatures_mark = [
        { name: supervisor.name,
          role: supervisor_role,
          date: I18n.l(professor_signature_signed.updated_at, format: :short),
          time: I18n.l(professor_signature_signed.updated_at, format: :time) },
        { name: external_member.name,
          role: external_member_role,
          date: I18n.l(external_member_signature_signed.updated_at, format: :short),
          time: I18n.l(external_member_signature_signed.updated_at, format: :time) },
        { name: academic.name,
          role: academic_role,
          date: I18n.l(academic_signature_signed.updated_at, format: :short),
          time: I18n.l(academic_signature_signed.updated_at, format: :time) },
        { name: professor.name,
          role: professor_role,
          date: I18n.l(signature_signed.updated_at, format: :short),
          time: I18n.l(signature_signed.updated_at, format: :time) }
      ]
      expect(orientation.signatures_mark).to match_array(signatures_mark)
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
    it 'returns true' do
      orientation = create(:orientation_tcc_one)
      expect(orientation.can_be_edited?).to eq(true)
    end

    it 'returns false' do
      signature = create(:signature, status: true)
      orientation = create(:orientation_tcc_one)
      orientation.signatures << signature
      expect(orientation.can_be_edited?).to eq(false)
    end
  end

  describe '#can_be_destroyed?' do
    it 'returns true' do
      signature = create(:signature, status: false)
      orientation = create(:orientation_tcc_one)
      orientation.signatures << signature
      expect(orientation.can_be_destroyed?).to eq(true)
    end

    it 'returns false' do
      signature = create(:signature, status: true)
      orientation = create(:orientation_tcc_one)
      orientation.signatures << signature
      expect(orientation.can_be_destroyed?).to eq(false)
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
      formatted = [{ name: "#{professor.scholarity.abbr} #{professor.name}" }]
      expect(orientation.professor_supervisors_to_document).to match_array(formatted)
    end
  end

  describe '#external_member_supervisors_to_document' do
    let(:orientation) { create(:orientation) }
    let(:external_member) { orientation.external_member_supervisors.first }

    it 'returns the array with professor supervisors name formatted' do
      formatted = [{ name: "#{external_member.scholarity.abbr} #{external_member.name}" }]
      expect(orientation.external_member_supervisors_to_document).to match_array(formatted)
    end
  end

  describe '#signature_status' do
    let!(:orientation) { create(:orientation) }
    let!(:professor) { create(:professor) }
    let!(:signature) do
      create(:signature, orientation_id: orientation.id, user_id: professor.id)
    end

    before do
      orientation.signatures << signature
    end

    it 'returns the signature status' do
      signature_status = [
        { name: signature.user_table.find(signature.user_id).name, status: signature.status }
      ]
      expect(orientation.signatures_status).to match_array(signature_status)
    end
  end
end
