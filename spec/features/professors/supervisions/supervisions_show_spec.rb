require 'rails_helper'

describe 'Supervision::show' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
  let(:calendar_tcc_two) { create(:current_calendar_tcc_two) }
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
    context 'when shows the orientation' do
      it 'shows the orientation' do
        visit professors_supervision_path(orientation)

        expect_contents_of(orientation)

        breadcrumb_text = I18n.t('breadcrumbs.supervisions.history')
        first("a[href='#{professors_supervisions_history_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_supervisions_history_path
      end
    end

    context 'when shows the current tcc one orientation' do
      it 'shows the current tcc one orientation' do
        visit professors_supervision_path(orientation_tcc_one)
        expect_contents_of(orientation_tcc_one)

        breadcrumb_text = I18n.t('breadcrumbs.supervisions.tcc.one.calendar',
                                 calendar: calendar_tcc_one.year_with_semester)
        first("a[href='#{professors_supervisions_tcc_one_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_supervisions_tcc_one_path
      end
    end

    context 'when shows the current tcc two orientation' do
      it 'shows the current tcc two orientation' do
        visit professors_supervision_path(orientation_tcc_two)

        expect_contents_of(orientation_tcc_two)

        breadcrumb_text = I18n.t('breadcrumbs.supervisions.tcc.two.calendar',
                                 calendar: calendar_tcc_two.year_with_semester)
        first("a[href='#{professors_supervisions_tcc_two_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_supervisions_tcc_two_path
      end
    end
  end

  def expect_contents_of(orientation)
    expect(page).to have_content(orientation.title)
    expect(page).to have_content(orientation.academic.name)
    expect(page).to have_content(orientation.advisor.name)

    orientation.calendars.each do |calendar|
      expect(page).to have_content(calendar.year_with_semester_and_tcc)
    end

    expect(page).to have_content(complete_date(orientation.created_at))
    expect(page).to have_content(complete_date(orientation.updated_at))
  end
end
