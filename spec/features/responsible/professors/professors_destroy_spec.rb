require 'rails_helper'

describe 'Professor::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:professor) { create(:professor) }
  let(:resource_name) { Professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professors_path
  end

  describe '#destroy' do
    context 'when professor is destroyed', js: true do
      it 'show success message' do
        url = responsible_professor_path(professor)
        destroy_link = "a[href='#{url}'][data-method='delete']"
        find(destroy_link).click
        accept_alert

        expect(page).to have_flash(:success, text: flash_message('destroy.m', resource_name))
        expect(page).not_to have_content(professor.name)
      end
    end
  end
end
