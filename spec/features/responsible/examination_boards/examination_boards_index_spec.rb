require 'rails_helper'

describe 'ExaminationBoard::index', :js do
  let(:responsible) { create(:responsible) }
  let!(:ebs) { [] }

  before do
    create(:current_calendar_tcc_one)
    @current_calendar_tcc_two = create(:current_calendar_tcc_two, 
                                       start_date: 2.days.ago,
                                       end_date: 2.days.from_now)

    login_as(responsible, scope: :professor)
  end

  context 'when shows all the examination boards of the tcc one calendar' do
    before do
      ebs.concat(create_list(:examination_board_tcc_one, 2, date: 6.months.ago))
      ebs.concat(create_list(:examination_board_tcc_one, 2, date: 1.day.ago))

      visit responsible_examination_boards_tcc_one_path
    end

    it 'shows all the examination boards of the tcc one with options' do
      ebs.each do |examination_board|
        academic_link_text = examination_board.orientation.academic_with_calendar
        expect(page).to have_link(academic_link_text, 
                                  href: responsible_examination_board_path(examination_board), 
                                  match: :first)
        expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end
  end

  context 'when shows the current examination boards of the tcc one' do
    before do
      ebs.concat(create_list(:examination_board_tcc_one, 2, date: 1.day.ago))
      create_list(:examination_board_tcc_one, 2, date: 6.months.ago)

      visit responsible_examination_boards_tcc_one_current_semester_path
    end

    it 'shows all the examination boards of the tcc one with options' do
      ebs.each do |examination_board|
      academic_link_text = examination_board.orientation.academic_with_calendar
      expect(page).to have_link(academic_link_text, 
                                href: responsible_examination_board_path(examination_board), 
                                match: :first)
        expect(page).to have_contents([examination_board.orientation.advisor.name,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end
  end

  context 'when shows all the examination boards of the tcc two calendar' do
    before do
      ebs.concat(create_list(:examination_board_tcc_two, 2, date: 1.day.ago))
      ebs.concat(create_list(:examination_board_tcc_two, 2, date: 6.months.ago))

      visit responsible_examination_boards_tcc_two_path
    end

    it 'shows all the examination boards of the tcc two with options' do
      ebs.each do |examination_board|
      academic_link_text = examination_board.orientation.academic_with_calendar
      expect(page).to have_link(academic_link_text, 
                                href: responsible_examination_board_path(examination_board), 
                                match: :first)
        expect(page).to have_contents([examination_board.orientation.advisor.name,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end
  end
end
