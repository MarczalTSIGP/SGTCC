require 'rails_helper'

describe 'Academics', type: :feature do
  let(:professor) { create(:professor) }
  let(:resource_name) { Academic.model_name.human }

  before(:each) do
    login_as(professor, scope: :professor)
  end

  describe '#update' do
    let(:academic) { create(:academic) }

    before(:each) do
      visit edit_professors_academic_path(academic)
    end

    context 'with valid fields' do
      it 'update academic' do
        attributes = attributes_for(:academic)

        new_name = 'Teste'
        fill_in 'academic_name', with: new_name
        fill_in 'academic_email', with: attributes[:email]

        choose 'academic_gender_female'

        submit_form

        expect(page.current_path).to eq professors_academics_path
        expect_alert_success(resource_name, 'flash.actions.update.m')

        within('table tbody') do
          expect(page).to have_content(new_name)
        end
      end
    end

    context 'with invalid fields' do
      it 'show errors' do
        fill_in 'academic_name', with: ''
        fill_in 'academic_email', with: ''
        submit_form

        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))

        within('div.academic_name') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.academic_email') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end
      end
    end
  end
end
