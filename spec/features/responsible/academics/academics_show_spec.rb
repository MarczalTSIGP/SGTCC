require 'rails_helper'

describe 'Academics::show', type: :feature do
  describe '#show' do
    context 'when shows the academic' do
      it 'shows the academic' do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        academic = create(:academic)
        visit responsible_academic_path(academic)

        gender = I18n.t("enums.genders.#{academic.gender}")

        expect(page).to have_contents([academic.name,
                                       academic.email,
                                       academic.ra,
                                       gender,
                                       complete_date(academic.created_at),
                                       complete_date(academic.updated_at)])
      end
    end
  end
end
