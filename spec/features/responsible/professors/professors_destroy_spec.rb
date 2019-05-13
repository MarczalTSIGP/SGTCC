require 'rails_helper'

describe 'Professor::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:professor) { create(:professor) }
  let(:resource_name) { Professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professors_path
  end

  describe '#destroy' do
    context 'when professor is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_professor_path(professor))
        accept_alert

        expect(page).to have_flash(:success, text: message('destroy.m'))
        expect(page).not_to have_content(professor.name)
      end
    end
  end
end
