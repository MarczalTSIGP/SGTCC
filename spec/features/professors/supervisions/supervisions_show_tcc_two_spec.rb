require 'rails_helper'

describe 'Supervision::show' do
  let(:professor) { create(:professor) }
  let(:other_professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: other_professor) }
  let(:calendar_tcc_one) do
    Calendar.find_by(year: Calendar.current_year, semester: Calendar.current_semester,
                     tcc: Calendar.tccs[:one]) ||
      create(:calendar, :current, :tcc_one)
  end

  let(:calendar_tcc_two) do
    Calendar.find_by(year: Calendar.current_year, semester: Calendar.current_semester,
                     tcc: Calendar.tccs[:two]) ||
      create(:calendar, :current, :tcc_two)
  end

  let(:orientation_tcc_one) do
    create(:orientation, advisor: professor,
                         calendars: [calendar_tcc_one])
  end
  let(:orientation_tcc_two) do
    create(:orientation, advisor: professor,
                         calendars: [calendar_tcc_two])
  end

  before do
    professor.supervisions << orientation
    professor.supervisions << orientation_tcc_one
    professor.supervisions << orientation_tcc_two
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the current tcc two orientation' do
      it 'shows the current tcc two orientation' do
        visit professors_supervision_path(orientation_tcc_two)

        expect_orientation_show_basic_information(orientation_tcc_two)

        breadcrumb_text = I18n.t('breadcrumbs.supervisions.tcc.two.calendar',
                                 calendar: calendar_tcc_two.year_with_semester)
        first("a[href='#{professors_supervisions_tcc_two_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_supervisions_tcc_two_path
      end
    end
  end
end
