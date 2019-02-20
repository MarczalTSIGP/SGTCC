require 'rails_helper'

describe 'Academics', type: :feature do
  let(:professor) { create(:professor) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_academic_path
    end

    context 'with valid fields', js: true do
      it 'create academic' do
        attributes = attributes_for(:academic)
        fill_in 'academic_name',   with: attributes[:name]
        fill_in 'academic_email',  with: attributes[:email]
        fill_in 'academic_ra',     with: attributes[:ra]
        choose 'academic_gender_male'

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_academics_path
        expect_alert_success(resource_name, 'flash.actions.create.m')

        sleep 3.seconds

        within('table tbody') do
          expect(page).to have_content(attributes[:name])
        end
      end
    end

    context 'with invalid fields' do
      it 'show errors' do
        submit_form

        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))

        within('div.academic_name') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.academic_email') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.academic_ra') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('fieldset.academic_gender') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end
      end
    end
  end
end
