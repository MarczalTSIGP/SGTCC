require 'rails_helper'

describe 'Professors::show', type: :feature do
  describe '#show' do
    context 'when shows the professor' do
      it 'shows the professor' do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        professor = create(:professor)
        visit responsible_professor_path(professor)

        gender = I18n.t("enums.genders.#{professor.gender}")
        is_active = I18n.t("helpers.boolean.#{professor.is_active}")
        available_advisor = I18n.t("helpers.boolean.#{professor.available_advisor}")

        expect(page).to have_content(professor.name)
        expect(page).to have_content(professor.email)
        expect(page).to have_content(professor.username)
        expect(page).to have_content(professor.lattes)
        expect(page).to have_content(gender)
        expect(page).to have_content(is_active)
        expect(page).to have_content(available_advisor)
        expect(page).to have_content(professor.professor_title.name)
        expect(page).to have_content(professor.professor_type.name)

        expect(page).to have_content(complete_date(professor.created_at))
        expect(page).to have_content(complete_date(professor.updated_at))
      end
    end
  end
end
