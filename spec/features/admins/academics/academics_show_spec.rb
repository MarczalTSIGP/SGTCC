require 'rails_helper'

describe 'Academics', type: :feature do
  describe '#show' do
    context 'show academics' do
      it 'show academic page' do
        admin = create(:admin)
        login_as(admin, scope: :admin)

        academic = create(:academic)
        visit admins_academic_path(academic)

        gender = I18n.t("enums.genders.#{academic.gender}")

        expect(page).to have_content(academic.name)
        expect(page).to have_content(academic.email)
        expect(page).to have_content(academic.ra)
        expect(page).to have_content(gender)
        expect(page).to have_content(complete_date(academic.created_at))
        expect(page).to have_content(complete_date(academic.updated_at))
      end
    end
  end
end
