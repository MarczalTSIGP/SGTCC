require 'rails_helper'

describe 'Academic::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:academic) { create(:academic) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_academics_path
  end

  describe '#destroy' do
    context 'when academic is destroyed', js: true do
      it 'show success message' do
        within first('.destroy').click
        accept_alert
        expect(page).to have_flash(:success, text: flash_message('destroy.m', resource_name))
        expect(page).not_to have_content(academic.name)
      end
    end
  end
end
