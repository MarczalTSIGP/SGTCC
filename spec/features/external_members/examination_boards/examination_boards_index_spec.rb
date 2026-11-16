require 'rails_helper'

describe 'ExaminationBoard::index', :js do
  let(:external_member) { create(:external_member) }
  let!(:examination_board) { create(:examination_board, :tcc_one) }

  before do
    examination_board.external_members << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_examination_boards_path
  end

  it 'separates history and keeps the selected period when searching' do
    past_orientation = create(:orientation, :previous, :tcc_one)
    past_board = create(
      :examination_board, :tcc_one, date: 1.year.ago, orientation: past_orientation
    )
    past_board.external_members << external_member
    visit external_members_examination_boards_path

    expect(page).to have_css("#examination_board_#{examination_board.id}")
    expect(page).to have_no_css("#examination_board_#{past_board.id}")
    within('.nav-tabs') { click_link 'Histórico' }
    expect(page).to have_current_path(%r{/history$})
    expect(page).to have_css("#examination_board_#{past_board.id}")
    expect(page).to have_no_css("#examination_board_#{examination_board.id}")

    fill_in 'term', with: past_board.orientation.title
    find_by_id('search').click
    expect(page).to have_current_path(%r{/history\?})
    expect(URI.parse(page.current_url).query).not_to include('period=')
    expect(page).to have_css('.nav-link.active', text: 'Histórico')
    expect(page).to have_css("#examination_board_#{past_board.id}")

    within('.nav-tabs') { click_link "#{Calendar.current_year}/#{Calendar.current_semester}" }
    expect(page).to have_current_path(%r{/current_semester\?})
    expect(page).to have_no_css("#examination_board_#{past_board.id}")
  end

  describe '#index' do
    context 'when shows the examination boards of the tcc one calendar' do
      it 'shows the examination boards of the tcc one with options' do
        expect(page).to have_link(examination_board.orientation.academic_with_calendar,
                                  href: external_members_examination_board_path(examination_board))
        expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])

        # examination_board.professors.each do |professor|
        #   expect(page).to have_content(professor.name_with_scholarity)
        # end
        #
        # examination_board.external_members.each do |external_member|
        #   expect(page).to have_content(external_member.name_with_scholarity)
        # end
      end
    end
  end
end
