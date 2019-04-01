require 'rails_helper'

describe 'Professors::show', type: :feature do
  describe '#show' do
    context 'when shows the professor' do
      it 'shows the professor' do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        professor = create(:professor)
        visit responsible_professor_path(professor)

        gender = I18n.t("enums.genders.#{professor.gender}")
        is_active = I18n.t("helpers.boolean.#{professor.is_active}")
        available_advisor = I18n.t("helpers.boolean.#{professor.available_advisor}")

        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       professor.username,
                                       professor.lattes,
                                       gender,
                                       is_active,
                                       available_advisor,
                                       professor.scholarity.name,
                                       professor.professor_type.name,
                                       complete_date(professor.created_at),
                                       complete_date(professor.updated_at)])
      end
    end
  end
end
