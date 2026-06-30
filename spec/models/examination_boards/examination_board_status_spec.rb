require 'rails_helper'

RSpec.describe ExaminationBoard do
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
end
