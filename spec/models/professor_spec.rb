require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:lattes) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:working_area) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_length_of(:email) }
    it { is_expected.to validate_length_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    context 'when email is valid' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
    end

    context 'when email is not valid' do
      it { is_expected.not_to allow_value('foo').for(:email) }
    end

    context 'when lattes is valid' do
      it { is_expected.to allow_value('http://lattes.com/link').for(:lattes) }
    end

    context 'when lattes is not valid' do
      it { is_expected.not_to allow_value('lattes.com').for(:lattes) }
    end

    context 'when professor supervisors is not valid' do
      let(:advisor) { build(:professor) }
      let(:orientation) { build(:orientation, advisor: advisor) }

      it 'validation should reject invalid orientation' do
        orientation.professor_supervisors << advisor
        orientation.save
        expect(orientation.errors[:professor_supervisors]).not_to be_empty
      end
    end
  end

  describe 'associations' do
    professor_sfk = 'professor_supervisor_id'
    it { is_expected.to belong_to(:professor_type) }
    it { is_expected.to belong_to(:scholarity) }
    it { is_expected.to have_many(:roles).through(:assignments) }
    it { is_expected.to have_many(:meetings).through(:orientations) }
    it { is_expected.to have_many(:assignments).dependent(:destroy) }
    it { is_expected.to have_many(:orientations).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:professor_supervisors).with_foreign_key(professor_sfk) }
    it { is_expected.to have_many(:supervisions).through(:professor_supervisors) }
    it { is_expected.to have_many(:all_documents).through(:supervisions) }
    it { is_expected.to have_many(:examination_board_attendees) }
    it { is_expected.to have_many(:guest_examination_boards).through(:examination_board_attendees) }
    it { is_expected.to have_many(:orientation_examination_boards).through(:orientations) }
    it { is_expected.to have_many(:supervision_examination_boards).through(:supervisions) }
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = described_class.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(described_class.human_genders).to eq(hash)
    end
  end

  describe '#role?' do
    let(:responsible) { create(:responsible) }

    it 'returns true if the professor has role' do
      expect(responsible.role?('responsible')).to eq(true)
    end

    it 'returns false if the professor has not role' do
      expect(responsible.role?('tcc_one')).to eq(false)
    end
  end

  describe '#search' do
    let(:responsible) { create(:responsible) }
    let(:professor) { create(:professor_tcc_one) }

    context 'when finds professor by attributes' do
      it 'returns professor by name' do
        results_search = described_class.search(professor.name)
        expect(professor.name).to eq(results_search.first.name)
      end

      it 'returns professor by email' do
        results_search = described_class.search(professor.email)
        expect(professor.email).to eq(results_search.first.email)
      end

      it 'returns professor by username' do
        results_search = described_class.search(professor.username)
        expect(professor.username).to eq(results_search.first.username)
      end

      it 'returns professor by role name' do
        results_search = described_class.search(responsible.roles.first.name)
        expect(responsible.name).to eq(results_search.first.name)
      end

      it 'returns professor by role identifier' do
        results_search = described_class.search(responsible.roles.first.identifier)
        expect(responsible.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name with accents' do
      it 'returns professor' do
        professor = create(:responsible, name: 'João')
        results_search = described_class.search('Joao')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name on search term with accents' do
      it 'returns professor' do
        professor = create(:responsible, name: 'Joao')
        results_search = described_class.search('João')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name ignoring the case sensitive' do
      it 'returns professor by attribute' do
        professor = create(:professor_tcc_one, name: 'Ana')
        results_search = described_class.search('an')
        expect(professor.name).to eq(results_search.first.name)
      end

      it 'returns professor by search term' do
        professor = create(:professor_tcc_one, name: 'ana')
        results_search = described_class.search('AN')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when returns professors ordered by name' do
      it 'returns ordered' do
        create_list(:professor_tcc_one, 30)
        professors_ordered = described_class.order(:name)
        professor = professors_ordered.first
        results_search = described_class.search.order(:name)
        expect(professor.name).to eq(results_search.first.name)
      end
    end
  end

  describe '#documents_signed' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }
    let(:distinct_query) { 'DISTINCT ON (documents.id) documents.*' }

    before do
      orientation.signatures.find_by(user_type: :advisor).sign
    end

    it 'returns the signed documents' do
      conditions = { user_id: professor.id, user_type: 'AD', status: true }
      documents = Document.joins(:signatures).select(distinct_query).where(signatures: conditions)
      expect(professor.documents_signed).to match_array(documents)
    end
  end

  describe '#documents_pending' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }
    let(:distinct_query) { 'DISTINCT ON (documents.id) documents.*' }

    it 'returns the pending documents' do
      conditions = { user_id: professor.id, user_type: 'AD', status: false }
      documents = Document.joins(:signatures)
                          .select(distinct_query)
                          .where(signatures: conditions, request: nil)
      expect(professor.documents_pending).to match_array(documents)
    end
  end

  describe '#documents_reviewing' do
    let!(:orientation) { create(:orientation) }
    let!(:professor) { orientation.advisor }

    before do
      create(:document_tdo, orientation_id: orientation.id)
    end

    it 'returns the reviewing documents' do
      data = professor.documents.with_relationships.where.not(request: nil)
      data = data.select do |document|
        document.send("#{document.document_type.identifier}_for_review?")
      end
      expect(professor.documents_reviewing).to match_array(data)
    end
  end

  describe '#documents_request' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }
    let(:document_tdo) { create(:document_tdo, orientation_id: orientation.id) }
    let(:distinct_query) { 'DISTINCT ON (documents.id) documents.*' }

    it 'returns the reviewing documents' do
      conditions = { user_id: professor.id, user_type: 'AD', status: false }
      documents = Document.joins(:signatures)
                          .select(distinct_query)
                          .where(signatures: conditions)
                          .where(document_types: { identifier: :tdo })
                          .where.not(request: nil)
                          .with_relationships
      expect(professor.documents_request).to match_array(documents)
    end
  end

  describe '#orientations_to_form' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }

    it 'is equal professor request data' do
      order_by = 'calendars.year DESC, calendars.semester ASC, calendars.tcc ASC, academics.name'
      data = professor.orientations.includes(:academic, :calendars)
                      .order(order_by).map do |orientation|
                        [orientation.id, orientation.academic_with_calendar]
                      end
      expect(professor.orientations_to_form).to eq(data)
    end
  end

  describe '#current_responsible' do
    before do
      create(:responsible)
    end

    it 'is equal current responsible' do
      responsible = described_class.joins(:roles).find_by('roles.identifier': :responsible)
      expect(described_class.current_responsible).to eq(responsible)
    end
  end

  describe '#current_coordinator' do
    before do
      create(:coordinator)
    end

    it 'is equal current coordinator' do
      coordinator = described_class.joins(:roles).find_by('roles.identifier': :coordinator)
      expect(described_class.current_coordinator).to eq(coordinator)
    end
  end

  describe '#name_with_scholarity' do
    let(:professor) { create(:professor) }

    it 'is equal name with scholarity' do
      name_with_scholarity = "#{professor.scholarity.abbr} #{professor.name}"
      expect(professor.name_with_scholarity).to eq(name_with_scholarity)
    end
  end

  describe '#examination_boards' do
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let(:examination_board_tcc_one) { create(:examination_board_tcc_one) }

    before do
      create(:examination_board, orientation: orientation)
      examination_board_tcc_one.professors << professor
    end

    it 'is equal guest_examination_boards' do
      examination_boards = (professor.guest_examination_boards +
        professor.orientation_examination_boards)
      expect(professor.examination_boards).to match_array(examination_boards)
      expect(professor.examination_boards.count).to eq(2)
    end
  end

  describe '#examination_boards_by_tcc_one_list' do
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let(:examination_board_tcc_one) { create(:examination_board_tcc_one) }

    before do
      create(:examination_board, orientation: orientation)
      examination_board_tcc_one.professors << professor
    end

    it 'returns examination boards filtered by TCC One' do
      page = 1
      term = 'test'
      status = 'CURRENT_SEMESTER'

      filtered_examination_boards = (
        professor.guest_examination_boards.by_tcc_one(page, term, status) +
        professor.orientation_examination_boards.by_tcc_one(page, term, status)
      )

      expect(professor.examination_boards_by_tcc_one_list(page, term, status))
        .to match_array(filtered_examination_boards)

      expect(professor.examination_boards_by_tcc_one_list(page, term, status).count)
        .to eq(filtered_examination_boards.count)
    end
  end

  describe '#examination_boards_by_tcc_two_list' do
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let(:examination_board_tcc_two) { create(:examination_board_tcc_two) }

    before do
      create(:examination_board, orientation: orientation)
      examination_board_tcc_two.professors << professor
    end

    it 'returns examination boards filtered by TCC Two' do
      page = 1
      term = 'test'
      status = 'CURRENT_SEMESTER'

      filtered_examination_boards = (
        professor.guest_examination_boards.by_tcc_two(page, term, status) +
        professor.orientation_examination_boards.by_tcc_two(page, term, status)
      )

      expect(professor.examination_boards_by_tcc_two_list(page, term, status))
        .to match_array(filtered_examination_boards)

      expect(professor.examination_boards_by_tcc_two_list(page, term, status).count)
        .to eq(filtered_examination_boards.count)
    end
  end

  describe '#responsible?' do
    let(:responsible) { create(:responsible) }
    let(:professor) { create(:professor) }

    it 'returns true' do
      expect(responsible.responsible?).to eq(true)
    end

    it 'returns false' do
      expect(professor.responsible?).to eq(false)
    end
  end

  describe '#tcc_one_approved' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation_tcc_one, advisor: professor) }

    it 'returns the tcc one approved' do
      orientations_approved = professor.orientations.tcc_one('APPROVED')
      expect(professor.tcc_one_approved).to eq(orientations_approved)
    end
  end

  describe '#tcc_two_approved' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation_tcc_two, advisor: professor) }

    it 'returns the tcc two approved' do
      orientations_approved = professor.orientations.tcc_two('APPROVED')
      expect(professor.tcc_two_approved).to eq(orientations_approved)
    end
  end

  describe '#tcc_one_in_progress' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation_tcc_one, advisor: professor) }

    it 'returns the tcc one in progress' do
      orientations_approved = professor.orientations.tcc_one('IN_PROGRESS')
      expect(professor.tcc_one_in_progress).to eq(orientations_approved)
    end
  end

  describe '#tcc_two_in_progress' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation_tcc_two, advisor: professor) }

    it 'returns the tcc two in progress' do
      orientations_approved = professor.orientations.tcc_two('IN_PROGRESS')
      expect(professor.tcc_two_in_progress).to eq(orientations_approved)
    end
  end

  describe '#effective' do
    let(:professor_type) { create(:professor_type, name: 'Efetivo') }
    let(:professor) { create(:professor, professor_type: professor_type) }

    it 'returns the effective professors' do
      expect(described_class.effective).to eq([professor])
    end
  end

  describe '#temporary' do
    let(:professor_type) { create(:professor_type, name: 'Temporário') }
    let(:professor) { create(:professor, professor_type: professor_type) }

    it 'returns the temporary professors' do
      expect(described_class.temporary).to eq([professor])
    end
  end

  describe '#current_semester_supervision_examination_boards' do
    let(:examination_board) { create(:examination_board) }
    let(:professor) { examination_board.professors.first }

    it 'returns the supervision by current semester' do
      supervisions = professor.supervision_examination_boards.current_semester.with_relationships
      expect(professor.current_semester_supervision_examination_boards).to eq(supervisions)
    end
  end
end
