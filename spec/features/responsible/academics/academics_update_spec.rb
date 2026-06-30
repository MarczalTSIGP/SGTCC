require 'rails_helper'

describe 'Academic::update', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:academic) { create(:academic) }

    before do
      visit edit_responsible_academic_path(academic)
    end

    context 'when data is valid' do
      it 'updates the academic' do
        attributes = attributes_for(:academic)
        fill_in 'academic_name', with: attributes[:name]
        fill_in 'academic_email', with: attributes[:email]
        fill_in 'academic_ra', with: attributes[:ra]
        gender = I18n.t("enums.genders.#{attributes[:gender]}")
        click_on_label(gender, in: 'academic_gender')

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_academic_path(academic)
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_contents([attributes[:name],
                                       attributes[:email],
                                       attributes[:ra],
                                       gender])
      end
    end

    context 'when the academic is not valid' do
      it_behaves_like 'responsible update blank errors',
                      fields: %w[academic_name academic_email academic_ra],
                      selectors: [
                        ['div.academic_name'],
                        ['div.academic_email'],
                        ['div.academic_ra']
                      ]
    end
  end
end
