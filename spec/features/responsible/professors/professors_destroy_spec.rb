require 'rails_helper'

describe 'Professor::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:professor) { create(:professor) }
  let(:resource_name) { Professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professors_path
  end

  describe '#destroy' do
    context 'when professor is destroyed' do
      let(:destroy_path) { responsible_professor_path(professor) }
      let(:destroyed_record_name) { professor.name }

      it_behaves_like 'responsible destroy success flow', message_key: 'destroy.m'
    end
  end

  describe '#destroy with associations' do
    let!(:advisor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor:) }

    context 'when professor has associations' do
      it 'show alert message' do
        visit responsible_professors_path
        click_on_destroy_link(responsible_professor_path(orientation.advisor))
        accept_alert
        expect(page).to have_flash(:warning, text: message('destroy.bond'))
        expect(page).to have_text(advisor.name)
      end
    end
  end
end
