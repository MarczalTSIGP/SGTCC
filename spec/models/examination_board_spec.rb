require 'rails_helper'

RSpec.describe ExaminationBoard, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:document_available_until) }
  end

  describe 'associations' do
    subject(:examination_board) { described_class.new }

    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to have_many(:examination_board_attendees).dependent(:delete_all) }
    it { is_expected.to have_many(:examination_board_notes).dependent(:delete_all) }

    it 'is expected to have many professors' do
      expect(examination_board).to have_many(:professors).through(:examination_board_attendees)
                                                         .dependent(:destroy)
    end

    it 'is expected to have many external members' do
      expect(examination_board).to have_many(:external_members)
        .through(:examination_board_attendees).dependent(:destroy)
    end
  end

  describe '#human_tcc_identifiers' do
    it 'returns the identifiers' do
      identifiers = described_class.identifiers
      hash = {}
      identifiers.each_key { |key| hash[I18n.t("enums.tcc.identifiers.#{key}")] = key }

      expect(described_class.human_tcc_identifiers).to eq(hash)
    end
  end

  describe '#human_tcc_one_identifiers' do
    it 'returns the tcc one identifiers' do
      hash = described_class.human_tcc_identifiers.first(2).to_h
      expect(described_class.human_tcc_one_identifiers).to eq(hash)
    end
  end

  describe '#search' do
    let!(:examination_board) { create(:examination_board) }

    context 'when finds examination_board by attributes' do
      it 'returns examination_board by orientation title' do
        results_search = described_class.search(examination_board.orientation.title)
        expect(examination_board.orientation.title).to eq(results_search.first.orientation.title)
      end

      it 'returns examination_board by place' do
        results_search = described_class.search(examination_board.place)
        expect(examination_board.place).to eq(results_search.first.place)
      end
    end
  end

  describe '#status' do
    context 'when returns the today status' do
      let(:examination_board) { create(:examination_board, date: Date.current) }

      it 'retuns the today status' do
        expect(examination_board.status).to eq('today')
      end
    end

    context 'when returns the next status' do
      let(:examination_board) { create(:examination_board, date: Date.current + 1.day) }

      it 'retuns the next status' do
        expect(examination_board.status).to eq('next')
      end
    end

    context 'when returns the occurred status' do
      let(:examination_board) { create(:examination_board, date: Date.current - 1.day) }

      it 'retuns the today occurred' do
        expect(examination_board.status).to eq('occurred')
      end
    end
  end

  describe '#distance_of_date' do
    include ActionView::Helpers::DateHelper

    let(:i18n) { 'views.tables.examination_board' }
    let(:date_current) { Date.current }

    context 'when returns the distance of today time' do
      let(:examination_board) { create(:examination_board, date: date_current) }
      let(:label) { I18n.t("#{i18n}.today", time: I18n.l(examination_board.date, format: :time)) }

      it 'retuns the today time label' do
        expect(examination_board.distance_of_date).to eq(label)
      end
    end

    context 'when returns the distance of next date' do
      let(:date) { Date.current + 1 }
      let(:examination_board) { create(:examination_board, date: date) }
      let(:label) do
        I18n.t("#{i18n}.next", distance: distance_of_time_in_words(date, Time.current))
      end

      it 'retuns the next date label' do
        expect(examination_board.distance_of_date).to eq(label)
      end
    end

    context 'when returns the distance of occurred date' do
      let(:date) { Date.current - 1 }
      let(:examination_board) { create(:examination_board, date: date) }
      let(:label) do
        I18n.t("#{i18n}.occurred", distance: distance_of_time_in_words(date, Time.current))
      end

      it 'retuns the occurred date label' do
        expect(examination_board.distance_of_date).to eq(label)
      end
    end
  end

  describe '#minutes_type' do
    context 'when the examination board is a proposal' do
      let(:examination_board) { create(:proposal_examination_board) }

      it 'retuns the adpp' do
        expect(examination_board.minutes_type).to eq(:adpp)
      end
    end

    context 'when the examination board is a project' do
      let(:examination_board) { create(:project_examination_board) }

      it 'retuns the adpj' do
        expect(examination_board.minutes_type).to eq(:adpj)
      end
    end

    context 'when the examination board is a monograph' do
      let(:examination_board) { create(:monograph_examination_board) }

      it 'retuns the admg' do
        expect(examination_board.minutes_type).to eq(:admg)
      end
    end
  end

  describe '#users_to_document' do
    let(:examination_board) { create(:examination_board) }
    let(:professors) { examination_board.professors }

    let(:professors_formatted) do
      professors.map do |professor|
        { id: professor.id, name: professor.name_with_scholarity }
      end
    end

    it 'returns the array with evaluators formatted' do
      expect(examination_board.users_to_document(professors)).to match_array(professors_formatted)
    end
  end

  describe '#available_defense_minutes?' do
    context 'when the document_available_until is greater than current time' do
      let(:examination_board) do
        create(:examination_board, date: Time.current,
                                   document_available_until: 1.day.from_now)
      end

      it 'returns true' do
        expect(examination_board.available_defense_minutes?).to eq(true)
      end
    end

    context 'when the document_available_until is less than current time' do
      let(:examination_board) do
        create(:examination_board, date: Time.current,
                                   document_available_until: 1.day.ago)
      end

      it 'returns false' do
        expect(examination_board.available_defense_minutes?).to eq(false)
      end
    end
  end

  describe '#create_defense_minutes' do
    context 'when create the defense minutes' do
      let(:examination_board) { create(:proposal_examination_board) }

      before do
        create(:document_type_adpp)
      end

      it 'returns the document created' do
        expect(examination_board.create_defense_minutes).to eq(Document.last)
      end
    end
  end

  describe '#create_non_attendance_defense_minutes' do
    context 'when create the non attendance defense minutes' do
      let(:examination_board) { create(:proposal_examination_board) }

      before do
        create(:document_type_adpp)
      end

      it 'returns the document created' do
        expect(examination_board.create_non_attendance_defense_minutes).to eq(Document.last)
      end
    end
  end

  describe '#defense_minutes' do
    context 'when returns the defense minutes' do
      let(:examination_board) { create(:proposal_examination_board) }

      before do
        create(:document_type_adpp)
      end

      it 'returns the defense minutes document' do
        defense_minutes = examination_board.create_defense_minutes
        expect(examination_board.defense_minutes).to eq(defense_minutes)
      end
    end
  end

  describe '#find_note_by_professor' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation, advisor: professor) }
    let(:examination_board) { create(:examination_board) }
    let!(:note) do
      create(:examination_board_note, examination_board: examination_board,
                                      professor: professor)
    end

    it 'returns the note by professor' do
      expect(examination_board.find_note_by_professor(professor)).to eq(note)
    end
  end

  describe '#find_note_by_external_member' do
    let(:orientation) { create(:orientation) }
    let(:external_member) { orientation.external_member_supervisors.first }
    let(:examination_board) { create(:examination_board) }
    let!(:note) do
      create(:examination_board_note, examination_board: examination_board,
                                      external_member: external_member)
    end

    it 'returns the note by external_member' do
      expect(examination_board.find_note_by_external_member(external_member)).to eq(note)
    end
  end

  describe '#advisor?' do
    context 'when the professor is the advisor' do
      let(:examination_board) { create(:examination_board) }
      let(:professor) { examination_board.orientation.advisor }

      it 'returns true' do
        expect(examination_board.advisor?(professor)).to eq(true)
      end
    end

    context 'when the professor is not the advisor' do
      let(:professor) { create(:professor) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.advisor?(professor)).to eq(false)
      end
    end
  end

  describe '#professor_evaluator?' do
    context 'when the professor is the evaluator' do
      let(:examination_board) { create(:examination_board) }
      let(:professor) { examination_board.professors.first }

      it 'returns true' do
        expect(examination_board.professor_evaluator?(professor)).to eq(true)
      end
    end

    context 'when the professor is not the evaluator' do
      let(:professor) { create(:professor) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.professor_evaluator?(professor)).to eq(false)
      end
    end
  end

  describe '#external_member_evaluator?' do
    context 'when the external member is the evaluator' do
      let(:examination_board) { create(:examination_board) }
      let(:external_member) { examination_board.external_members.first }

      it 'returns true' do
        expect(examination_board.external_member_evaluator?(external_member)).to eq(true)
      end
    end

    context 'when the external_member is not the evaluator' do
      let(:external_member) { create(:external_member) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.external_member_evaluator?(external_member)).to eq(false)
      end
    end
  end

  describe '.can_create_defense_minutes?' do
    context 'when is the advisor' do
      let(:examination_board) { create(:examination_board) }
      let(:professor) { examination_board.orientation.advisor }

      it 'returns true' do
        expect(examination_board.can_create_defense_minutes?(professor)).to eq(true)
      end
    end

    context 'when is the responsible' do
      let(:examination_board) { create(:examination_board) }
      let(:professor) { create(:responsible) }

      it 'returns true' do
        expect(examination_board.can_create_defense_minutes?(professor)).to eq(true)
      end
    end

    context 'when can not create' do
      let(:professor) { create(:professor) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.can_create_defense_minutes?(professor)).to eq(false)
      end
    end
  end

  describe '.appointments?' do
    context 'when has not appointments' do
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.appointments?).to eq(false)
      end
    end

    context 'when has appointments' do
      let!(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board: examination_board)
      end

      it 'returns true' do
        expect(examination_board.appointments?).to eq(true)
      end
    end
  end

  describe '.evaluators_size' do
    let(:examination_board) { create(:examination_board) }
    let(:advisor_size) { 1 }
    let(:professors_size) { examination_board.professors.size }
    let(:external_members_size) { examination_board.external_members.size }

    it 'returns the evaluators size' do
      size = advisor_size + professors_size + external_members_size
      expect(examination_board.evaluators_size).to eq(size)
    end
  end

  describe '.numbers_to_evaluate' do
    let(:examination_board) { create(:examination_board) }
    let(:examination_board_note) { examination_board.examination_board_notes }

    it 'returns the number to evaluate' do
      number_to_evaluate = examination_board.evaluators_size - examination_board_note.size
      expect(examination_board.number_to_evaluate).to eq(number_to_evaluate)
    end
  end

  describe '.all_evaluated' do
    let(:examination_board) { create(:examination_board) }
    let(:advisor_size) { 1 }
    let(:professors_size) { examination_board.professors.size }
    let(:external_members_size) { examination_board.external_members.size }

    it 'returns that all_evaluated is false' do
      examination_board.evaluators_number.times do
        create(:examination_board_note, examination_board: examination_board, note: nil)
      end

      expect(examination_board.all_evaluated?).to be(false)
    end

    it 'returns that all_evaluated is false when all give the note' do
      en = examination_board.evaluators_number - 1
      en.times do
        create(:examination_board_note, examination_board: examination_board, note: nil)
      end

      expect(examination_board.all_evaluated?).to be(false)
    end

    it 'returns that all_evaluated is true' do
      examination_board.evaluators_number.times do
        create(:examination_board_note, examination_board: examination_board, note: 80)
      end

      expect(examination_board.all_evaluated?).to be(true)
    end
  end
end
