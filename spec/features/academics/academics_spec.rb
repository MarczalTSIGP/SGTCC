require 'rails_helper'

describe 'Academics', type: :feature do
  let(:admin) { create(:professor) }
  let(:resource_name) { Academic.model_name.human }

  before(:each) do
    login_as(admin, scope: :professor)
  end

  describe '#index' do
    let!(:academics) { create_list(:academic, 3) }

    it 'show all academics with options' do
      visit academics_path

      academics.each do |a|
        expect(page).to have_content(a.name)

        expect(page).to have_link(href: edit_academic_path(a))
        destroy_link = "a[href='#{academic_path(a)}'][data-method='delete']"
        expect(page).to have_css(destroy_link)
      end
    end
  end

  describe '#show' do
    context 'show academics' do
      it 'show academic page' do
        academic = create(:academic)
        visit academic_path(academic)

        expect(page).to have_content(academic.name)
        expect(page).to have_content(academic.email)
        expect(page).to have_content(academic.ra)
        #expect(page).to have_content(academic.gender)
      end
    end
  end

  describe '#create' do
    before(:each) do
      visit new_academic_path
    end

    context 'with valid fields' do
      it 'create academic' do
        attributes = attributes_for(:academic)
        fill_in 'academic_name',   with: attributes[:name]
        fill_in 'academic_email',  with: attributes[:email]
        fill_in 'academic_ra',     with: attributes[:ra]
        choose 'academic_gender_male'

        submit_form

        expect(page.current_path).to eq academics_path
        expect_alert_success(resource_name, 'flash.actions.create.m')

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

  describe '#destroy' do
    it 'academic' do
      academic = create(:academic)
      visit academics_path

      within first('.destroy').click

      expect(page).to have_selector('div.alert.alert-success',
                                    text: I18n.t('flash.actions.destroy.m',
                                                 resource_name: resource_name))
      within('table tbody') do
        expect(page).not_to have_content(academic.name)
      end
    end
  end
end
