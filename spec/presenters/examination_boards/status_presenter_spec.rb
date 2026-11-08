require 'rails_helper'

RSpec.describe ExaminationBoards::StatusPresenter do
  include ActionView::Helpers::DateHelper

  let(:i18n) { 'views.tables.examination_board' }

  describe '#status' do
    context 'when the board date is today' do
      let(:board) { create(:examination_board, date: Date.current) }

      it 'returns today' do
        expect(described_class.new(board).status).to eq('today')
      end
    end

    context 'when the board date is in the future' do
      let(:board) { create(:examination_board, date: Date.current + 1.day) }

      it 'returns next' do
        expect(described_class.new(board).status).to eq('next')
      end
    end

    context 'when the board date is in the past' do
      let(:board) { create(:examination_board, date: Date.current - 1.day) }

      it 'returns occurred' do
        expect(described_class.new(board).status).to eq('occurred')
      end
    end
  end

  describe '#distance_of_date' do
    context 'when the board date is today' do
      let(:board) { create(:examination_board, date: Date.current) }
      let(:label) { I18n.t("#{i18n}.today", time: I18n.l(board.date, format: :time)) }

      it 'returns today time label' do
        expect(described_class.new(board).distance_of_date).to eq(label)
      end
    end

    context 'when the board date is in the future' do
      let(:date) { Date.current + 1 }
      let(:board) { create(:examination_board, date:) }
      let(:label) do
        I18n.t("#{i18n}.next", distance: distance_of_time_in_words(date, Time.current))
      end

      it 'returns next date label' do
        expect(described_class.new(board).distance_of_date).to eq(label)
      end
    end

    context 'when the board date is in the past' do
      let(:date) { Date.current - 1 }
      let(:board) { create(:examination_board, date:) }
      let(:label) do
        I18n.t("#{i18n}.occurred", distance: distance_of_time_in_words(date, Time.current))
      end

      it 'returns occurred date label' do
        expect(described_class.new(board).distance_of_date).to eq(label)
      end
    end
  end
end
