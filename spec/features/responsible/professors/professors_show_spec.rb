require 'rails_helper'

describe 'Professors::show' do
  let(:responsible) { create(:responsible) }
  let!(:professor) { create(:professor) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professor_path(professor)
  end

  describe '#show' do
    context 'when shows the professor' do
      it 'shows the professor' do
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
