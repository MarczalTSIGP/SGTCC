require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe '#professors_ranking' do
    let!(:professor_orientations) do
      create_list(:orientation, 4, :tcc_two, :approved, :with_final_monograph)
    end
    let!(:professors) { professor_orientations.map(&:advisor) }

    it 'returns the professors ranking data' do
      ranking = professors.map do |professor|
        [professor.name_with_scholarity, professor.orientations.size]
      end
      ranking = ranking.sort_by { |professor| professor[1] }.reverse
      expect(described_class.professors_ranking).to match_array(ranking)
    end
  end

  describe '#cs_asc_from_now_desc_ago' do
    let!(:current_calendar) do
      Calendar.where('? BETWEEN start_date AND end_date', Date.current).first ||
        create(:calendar, :tcc_one,
               year: '2099',
               semester: :one,
               start_date: 1.month.ago.to_date,
               end_date: 1.month.from_now.to_date)
    end

    it 'returns only examination boards within the current calendar period' do
      current_board = create(
        :examination_board,
        date: 2.hours.from_now,
        orientation: create(
          :orientation,
          calendars: [current_calendar]
        )
      )
      previous_calendar = create(:calendar, :previous, :tcc_one,
                                 year: current_calendar.year.to_i - 1,
                                 start_date: current_calendar.start_date - 1.year,
                                 end_date: current_calendar.end_date - 1.year)
      create(
        :examination_board,
        date: current_calendar.start_date.beginning_of_day - 1.hour,
        orientation: create(
          :orientation,
          calendars: [previous_calendar]
        )
      )

      expect(ExaminationBoard.cs_asc_from_now_desc_ago).to contain_exactly(current_board)
    end

    it 'orders upcoming examination boards ascending by date' do
      board_soon = create(
        :examination_board,
        date: 2.hours.from_now,
        orientation: create(
          :orientation,
          calendars: [current_calendar]
        )
      )
      board_later = create(
        :examination_board,
        date: 1.day.from_now,
        orientation: create(
          :orientation,
          calendars: [current_calendar]
        )
      )

      expect(ExaminationBoard.cs_asc_from_now_desc_ago.map(&:id)).to eq(
        [board_soon.id,
         board_later.id]
      )
    end

    it 'appends past examination boards in descending order after upcoming' do
      board_soon = create(
        :examination_board,
        date: 2.hours.from_now,
        orientation: create(
          :orientation,
          calendars: [current_calendar]
        )
      )
      board_recent_past = create(
        :examination_board,
        date: 1.day.ago,
        orientation: create(
          :orientation,
          calendars: [current_calendar]
        )
      )
      board_old_past = create(
        :examination_board,
        date: current_calendar.start_date.beginning_of_day,
        orientation: create(
          :orientation,
          calendars: [current_calendar]
        )
      )

      expect(ExaminationBoard.cs_asc_from_now_desc_ago.map(&:id))
        .to eq([board_soon.id, board_recent_past.id, board_old_past.id])
    end

    it 'does not duplicate examination boards when the orientation has multiple calendars' do
      overlapping_calendar = create(
        :calendar, :tcc_one,
        start_date: current_calendar.start_date,
        end_date: current_calendar.end_date
      )

      board = create(
        :examination_board,
        date: 2.hours.from_now,
        orientation: create(
          :orientation,
          calendars: [current_calendar, overlapping_calendar]
        )
      )

      expect(ExaminationBoard.cs_asc_from_now_desc_ago).to contain_exactly(board)
    end
  end
end
