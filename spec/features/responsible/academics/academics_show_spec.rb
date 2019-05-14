require 'rails_helper'

describe 'Academics::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:academic) { create(:academic) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_academic_path(academic)
  end

  describe '#show' do
    context 'when shows the academic' do
      it 'shows the academic' do
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
