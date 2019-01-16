require 'rails_helper'

describe 'Academics', type: :feature do
  let(:admin) { create(:admin) }
  let(:resource_name) { Academic.model_name.human }

  before(:each) do
    login_as(admin, scope: :admin)
  end

  describe '#update' do
    let(:academic) { create(:academic) }

    before(:each) do
      visit edit_academic_path(academic)
    end

    context 'fill fields' do
      it 'with correct values' do
        expect(page).to have_field 'academic_name',
                                   with: academic.name
        expect(page).to have_field 'academic_email',
                                   with: academic.email
      end
    end

    context 'with valid fields' do
      it 'update academic' do
        attributes = attributes_for(:academic)

        new_name = 'Teste'
        fill_in 'academic_name', with: new_name
        fill_in 'academic_email', with: attributes[:email]

        choose 'academic_gender_female'

        submit_form

        expect(page.current_path).to eq academics_path
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
