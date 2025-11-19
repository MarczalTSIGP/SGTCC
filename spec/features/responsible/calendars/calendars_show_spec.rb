require 'rails_helper'

describe 'Calendar::show', :js do
  let(:responsible) { create(:responsible) }
  let!(:calendar) { create(:calendar) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_calendar_path(calendar)
  end

  describe '#show' do
    context 'when shows the calendar' do
  it 'shows basic calendar header info' do
    tcc_label = I18n.t("enums.tcc.#{calendar.tcc}")
    expect(page).to have_content("Calendário de Atividades de TCC #{tcc_label} (#{calendar.year_with_semester})")
    expect(page).to have_content(calendar.year_with_semester)
  end

      it 'shows its activities or empty message' do
        if calendar.activities.empty?
          expect(page).to have_content('Nenhum resultado encontrado.')
        else
          calendar.activities.each do |activity|
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
  end
end
