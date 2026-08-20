require 'rails_helper'

describe 'Calendar::show', :js do
  let(:responsible) { create(:responsible) }
  let!(:calendar) { create(:calendar) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#show' do
    context 'when shows the calendar' do
      before { visit responsible_calendar_path(calendar) }

      it 'shows basic calendar header info' do
        tcc_label = I18n.t("enums.tcc.#{calendar.tcc}")
        title = "Calendário de Atividades de TCC #{tcc_label} (#{calendar.year_with_semester})"
        expect(page).to have_text(title)
        expect(page).to have_text(calendar.year_with_semester)
      end
    end

    context 'when the calendar has no activities' do
      before { visit responsible_calendar_path(calendar) }

      it 'shows the empty message' do
        expect(page).to have_text('Nenhum resultado encontrado.')
      end
    end

    context 'when the calendar has activities' do
      before do
        create(:activity, calendar: calendar)
        visit responsible_calendar_path(calendar)
      end

      it 'shows the activities' do
        activity = calendar.activities.first
        tcc = I18n.t("enums.tcc.#{activity.tcc}")
        expect(page).to have_contents([
                                        activity.name,
                                        activity.base_activity_type.name,
                                        tcc,
                                        short_date(activity.initial_date),
                                        short_date(activity.final_date)
                                      ])
      end
    end
  end
end
