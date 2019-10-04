require 'rails_helper'

RSpec.describe ExaminationBoard, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:document_available_until) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to have_many(:examination_board_attendees).dependent(:delete_all) }

    it 'is expected to have many professors' do
      is_expected.to have_many(:professors).through(:examination_board_attendees)
                                           .dependent(:destroy)
    end

    it 'is expected to have many external members' do
      is_expected.to have_many(:external_members).through(:examination_board_attendees)
                                                 .dependent(:destroy)
    end
  end

  describe '#human_tcc_identifiers' do
    it 'returns the identifiers' do
      identifiers = ExaminationBoard.identifiers
      hash = {}
      identifiers.each_key { |key| hash[I18n.t("enums.tcc.identifiers.#{key}")] = key }

      expect(ExaminationBoard.human_tcc_identifiers).to eq(hash)
    end
  end

  describe '#human_tcc_one_identifiers' do
    it 'returns the tcc one identifiers' do
      hash = ExaminationBoard.human_tcc_identifiers.first(2).to_h
      expect(ExaminationBoard.human_tcc_one_identifiers).to eq(hash)
    end
  end

  describe '#search' do
    let!(:examination_board) { create(:examination_board) }

    context 'when finds examination_board by attributes' do
      it 'returns examination_board by orientation title' do
        results_search = ExaminationBoard.search(examination_board.orientation.title)
        expect(examination_board.orientation.title).to eq(results_search.first.orientation.title)
      end

      it 'returns examination_board by place' do
        results_search = ExaminationBoard.search(examination_board.place)
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

  describe '#evaluators_to_document' do
    let(:examination_board) { create(:examination_board) }

    let(:evaluators_formatted) do
      examination_board.professors.map do |evaluator|
        { id: evaluator.id, name: evaluator.name_with_scholarity }
      end
    end

    it 'returns the array with evaluators formatted' do
      expect(examination_board.evaluators_to_document).to match_array(evaluators_formatted)
    end
  end

  describe '#available_defense_minutes?' do
    context 'when the document_available_until is greater than current time' do
      let(:examination_board) do
        create(:examination_board, date: Time.current, document_available_until: Time.current + 1)
      end

      it 'returns true' do
        expect(examination_board.available_defense_minutes?).to eq(true)
      end
    end

    context 'when the document_available_until is less than current time' do
      let(:examination_board) do
        create(:examination_board, date: Time.current, document_available_until: Time.current - 1)
      end

      it 'returns false' do
        expect(examination_board.available_defense_minutes?).to eq(false)
      end
    end
  end
end
