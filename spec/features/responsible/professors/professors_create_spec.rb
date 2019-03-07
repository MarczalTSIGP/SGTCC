require 'rails_helper'

describe 'Professor::create', type: :feature do
  let(:responsible) { create(:professor) }
  let(:resource_name) { Professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      @type = create_list(:professor_type, 2).sample
      @role = create_list(:professor_role, 3).sample
      @title = create_list(:professor_title, 2).sample

      visit new_responsible_professor_path
    end

    context 'when professor is valid', js: true do
      it 'create an professor' do
        attributes = attributes_for(:professor)
        fill_in 'professor_name', with: attributes[:name]
        fill_in 'professor_email', with: attributes[:email]
        fill_in 'professor_username', with: attributes[:username]
        fill_in 'professor_lattes', with: attributes[:lattes]

        within('div.editor-toolbar') do
          find('.fa-bold').click
        end

        select @title.name, from: 'professor[professor_title_id]'
        select @type.name, from: 'professor[professor_type_id]'
        select @role.name, from: 'professor[professor_role_id]'

        choose 'professor_gender_male'

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_professors_path
        success_message = I18n.t('flash.actions.create.m',
                                 resource_name: resource_name)

        expect(page).to have_flash(:success, text: success_message)

        within('table tbody') do
          expect(page).to have_content(attributes[:name])
        end
      end
    end

    context 'when professor is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))

        within('div.professor_name') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.professor_email') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.professor_username') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('fieldset.professor_gender') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end

        within('div.professor_lattes') do
          expect(page).to have_content(I18n.t('errors.messages.blank'))
        end
      end
    end
  end
end
