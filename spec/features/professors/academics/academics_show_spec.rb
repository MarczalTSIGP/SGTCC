require 'rails_helper'

describe 'Academics', type: :feature do
  describe '#show' do
    it 'show academic page' do
      professor = create(:professor)
      login_as(professor, scope: :professor)

      academic = create(:academic)
      visit professors_academic_path(academic)

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
