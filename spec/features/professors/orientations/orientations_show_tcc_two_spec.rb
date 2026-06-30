require 'rails_helper'

describe 'Orientation::show' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:calendar_tcc_one) { create(:calendar, :current, :tcc_one) }
  let(:calendar_tcc_two) { create(:calendar, :current, :tcc_two) }
  let(:orientation_tcc_one) do
    create(:orientation, advisor: professor,
                         calendars: [calendar_tcc_one])
  end
  let(:orientation_tcc_two) do
    create(:orientation, advisor: professor,
                         calendars: [calendar_tcc_two])
  end

  before do
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the current tcc two orientation' do
      it 'shows the current tcc two orientation' do
        visit professors_orientation_path(orientation_tcc_two)

        expect_orientation_show_basic_information(orientation_tcc_two)

        breadcrumb_text = I18n.t('breadcrumbs.orientations.tcc.two.calendar',
                                 calendar: calendar_tcc_two.year_with_semester)
        first("a[href='#{professors_orientations_tcc_two_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_orientations_tcc_two_path
      end
    end
  end
end
