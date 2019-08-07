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
    professor_fk = 'professor_id'
    it { is_expected.to belong_to(:professor_type) }
    it { is_expected.to belong_to(:scholarity) }
    it { is_expected.to have_many(:roles).through(:assignments) }
    it { is_expected.to have_many(:meetings).through(:orientations) }
    it { is_expected.to have_many(:assignments).dependent(:destroy) }
    it { is_expected.to have_many(:orientations).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:professor_supervisors).with_foreign_key(professor_sfk) }
    it { is_expected.to have_many(:supervisions).through(:professor_supervisors) }
    it { is_expected.to have_many(:examination_board_attendees).with_foreign_key(professor_fk) }
    it { is_expected.to have_many(:examination_boards).through(:examination_board_attendees) }
    it { is_expected.to have_many(:orientation_examination_boards).through(:orientations) }
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = Professor.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(Professor.human_genders).to eq(hash)
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
        results_search = Professor.search(professor.name)
        expect(professor.name).to eq(results_search.first.name)
      end

      it 'returns professor by email' do
        results_search = Professor.search(professor.email)
        expect(professor.email).to eq(results_search.first.email)
      end

      it 'returns professor by username' do
        results_search = Professor.search(professor.username)
        expect(professor.username).to eq(results_search.first.username)
      end

      it 'returns professor by role name' do
        results_search = Professor.search(responsible.roles.first.name)
        expect(responsible.name).to eq(results_search.first.name)
      end

      it 'returns professor by role identifier' do
        results_search = Professor.search(responsible.roles.first.identifier)
        expect(responsible.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name with accents' do
      it 'returns professor' do
        professor = create(:responsible, name: 'João')
        results_search = Professor.search('Joao')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name on search term with accents' do
      it 'returns professor' do
        professor = create(:responsible, name: 'Joao')
        results_search = Professor.search('João')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when finds professor by name ignoring the case sensitive' do
      it 'returns professor by attribute' do
        professor = create(:professor_tcc_one, name: 'Ana')
        results_search = Professor.search('an')
        expect(professor.name).to eq(results_search.first.name)
      end

      it 'returns professor by search term' do
        professor = create(:professor_tcc_one, name: 'ana')
        results_search = Professor.search('AN')
        expect(professor.name).to eq(results_search.first.name)
      end
    end

    context 'when returns professors ordered by name' do
      it 'returns ordered' do
        create_list(:professor_tcc_one, 30)
        professors_ordered = Professor.order(:name)
        professor = professors_ordered.first
        results_search = Professor.search.order(:name)
        expect(professor.name). to eq(results_search.first.name)
      end
    end
  end

  describe '#signatures_signed' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }

    before do
      orientation.signatures.find_by(user_type: :advisor).sign
    end

    it 'returns the signed signatures' do
      signatures = Signature.where(user_id: professor.id, user_type: 'AD', status: true)
      expect(professor.signatures_signed).to match_array(signatures)
    end
  end

  describe '#signatures_pending' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }

    it 'returns the pending signatures' do
      signatures = Signature.joins(:document)
                            .where(user_id: professor.id,
                                   user_type: 'AD', status: false)
      expect(professor.signatures_pending).to match_array(signatures)
    end
  end

  describe '#signatures_for_review' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }
    let(:document_tdo) { create(:document_tdo, orientation_id: orientation.id) }

    it 'returns the reviewing signatures' do
      signatures = Signature.joins(:document)
                            .where(user_id: professor.id,
                                   user_type: 'AD', status: false)
                            .where.not(documents: { request: nil })
      expect(professor.signatures_for_review).to match_array(signatures)
    end
  end

  describe '#orientations_to_form' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }

    it 'is equal professor request data' do
      order_by = 'calendars.year DESC, calendars.semester ASC, calendars.tcc ASC, academics.name'
      data = professor.orientations.includes(:academic, :calendar)
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
      responsible = Professor.joins(:roles).find_by('roles.identifier': :responsible)
      expect(Professor.current_responsible).to eq(responsible)
    end
  end

  describe '#current_coordinator' do
    before do
      create(:coordinator)
    end

    it 'is equal current coordinator' do
      coordinator = Professor.joins(:roles).find_by('roles.identifier': :coordinator)
      expect(Professor.current_coordinator).to eq(coordinator)
    end
  end

  describe '#name_with_scholarity' do
    let(:professor) { create(:professor) }

    it 'is equal name with scholarity' do
      name_with_scholarity = "#{professor.scholarity.abbr} #{professor.name}"
      expect(professor.name_with_scholarity).to eq(name_with_scholarity)
    end
  end

  describe '#guest_examination_boards' do
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let(:examination_board_tcc_one) { create(:examination_board_tcc_one) }

    before do
      create(:examination_board, orientation: orientation)
      examination_board_tcc_one.professors << professor
    end

    it 'is equal guest_examination_boards' do
      guest_examination_boards = (professor.examination_boards +
        professor.orientation_examination_boards)
      expect(professor.guest_examination_boards).to match_array(guest_examination_boards)
      expect(professor.guest_examination_boards.count).to eq(2)
    end
  end
end
