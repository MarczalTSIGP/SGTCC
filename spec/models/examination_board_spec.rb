require 'rails_helper'

RSpec.describe ExaminationBoard do
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
      let(:examination_board) { create(:examination_board, date:) }
      let(:label) do
        I18n.t("#{i18n}.next", distance: distance_of_time_in_words(date, Time.current))
      end

      it 'retuns the next date label' do
        expect(examination_board.distance_of_date).to eq(label)
      end
    end

    context 'when returns the distance of occurred date' do
      let(:date) { Date.current - 1 }
      let(:examination_board) { create(:examination_board, date:) }
      let(:label) do
        I18n.t("#{i18n}.occurred", distance: distance_of_time_in_words(date, Time.current))
      end

      it 'retuns the occurred date label' do
        expect(examination_board.distance_of_date).to eq(label)
      end
    end
  end

  describe '#find_note_by_professor' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation, advisor: professor) }
    let(:examination_board) { create(:examination_board) }
    let!(:note) do
      create(:examination_board_note, examination_board:,
                                      professor:)
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
      create(:examination_board_note, examination_board:,
                                      external_member:)
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
        expect(examination_board.advisor?(professor)).to be(true)
      end
    end

    context 'when the professor is not the advisor' do
      let(:professor) { create(:professor) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.advisor?(professor)).to be(false)
      end
    end
  end

  describe '#professor_evaluator?' do
    context 'when the professor is the evaluator' do
      let(:examination_board) { create(:examination_board) }
      let(:professor) { examination_board.professors.first }

      it 'returns true' do
        expect(examination_board.professor_evaluator?(professor)).to be(true)
      end
    end

    context 'when the professor is not the evaluator' do
      let(:professor) { create(:professor) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.professor_evaluator?(professor)).to be(false)
      end
    end
  end

  describe '#external_member_evaluator?' do
    context 'when the external member is the evaluator' do
      let(:examination_board) { create(:examination_board) }
      let(:external_member) { examination_board.external_members.first }

      it 'returns true' do
        expect(examination_board.external_member_evaluator?(external_member)).to be(true)
      end
    end

    context 'when the external_member is not the evaluator' do
      let(:external_member) { create(:external_member) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.external_member_evaluator?(external_member)).to be(false)
      end
    end
  end

  # describe '.can_create_defense_minutes?' do
  #   context 'when is the advisor' do
  #     let(:examination_board) { create(:examination_board) }
  #     let(:professor) { examination_board.orientation.advisor }

  #     it 'returns true' do
  #       expect(examination_board.can_create_defense_minutes?(professor)).to eq(true)
  #     end
  #   end

  #   context 'when is the responsible' do
  #     let(:examination_board) { create(:examination_board) }
  #     let(:professor) { create(:responsible) }

  #     it 'returns true' do
  #       expect(examination_board.can_create_defense_minutes?(professor)).to eq(true)
  #     end
  #   end

  #   context 'when can not create' do
  #     let(:professor) { create(:professor) }
  #     let(:examination_board) { create(:examination_board) }

  #     it 'returns false' do
  #       expect(examination_board.can_create_defense_minutes?(professor)).to eq(false)
  #     end
  #   end
  # end

  describe '.appointments?' do
    context 'when has not appointment file and appointment text' do
      let(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board:,
                                        appointment_file: nil,
                                        appointment_text: nil)
      end

      it 'returns false' do
        expect(examination_board.appointments?).to be(false)
      end
    end

    context 'when has appointment file and not have appointment text' do
      let!(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board:)
      end

      it 'returns true' do
        expect(examination_board.appointments?).to be(true)
      end
    end

    context 'when has appointment file and appointment text' do
      let!(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board:,
                                        appointment_text: 'Teste')
      end

      it 'returns true' do
        expect(examination_board.appointments?).to be(true)
      end
    end

    context 'when has not appointment file but has appointment text' do
      let!(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board:,
                                        appointment_file: nil,
                                        appointment_text: 'Texto de teste')
      end

      it 'returns true' do
        expect(examination_board.appointments?).to be(true)
      end
    end
  end

  describe '.all_evaluated' do
    let(:examination_board) { create(:examination_board) }
    let(:advisor_size) { 1 }
    let(:professors_size) { examination_board.professors.size }
    let(:external_members_size) { examination_board.external_members.size }

    it 'returns that all_evaluated is false' do
      examination_board.evaluators_number.times do
        create(:examination_board_note, examination_board:, note: nil)
      end

      expect(examination_board.all_evaluated?).to be(false)
    end

    it 'returns that all_evaluated is false when all give the note' do
      en = examination_board.evaluators_number - 1
      en.times do
        create(:examination_board_note, examination_board:, note: nil)
      end

      expect(examination_board.all_evaluated?).to be(false)
    end

    it 'returns that all_evaluated is true' do
      examination_board.evaluators_number.times do
        create(:examination_board_note, examination_board:, note: 80)
      end

      expect(examination_board.all_evaluated?).to be(true)
    end
  end
end
