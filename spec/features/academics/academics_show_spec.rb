require 'rails_helper'

describe 'Academics', type: :feature do
  describe '#show' do
    context 'show academics' do
      it 'show academic page' do
        admin = create(:professor)
        login_as(admin, scope: :professor)

        academic = create(:academic)
        visit academic_path(academic)

        gender = I18n.t("enums.genders.#{academic.gender}")

        expect(page).to have_content(academic.name)
        expect(page).to have_content(academic.email)
        expect(page).to have_content(academic.ra)
        expect(page).to have_content(gender)
      end
    end
  end
end
