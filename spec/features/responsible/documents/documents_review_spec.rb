require 'rails_helper'

describe 'Document::review', type: :feature do
  let!(:responsible) { create(:responsible) }
  let(:orientation) { create(:orientation, advisor: responsible) }
  let(:document) { create(:document_tdo, orientation_id: orientation.id) }
  let!(:signature) do
    create(:signature, user_id: responsible.id,
                       user_type: 'professor_responsible',
                       orientation: orientation,
                       document: document)
  end
  let(:resource_name) { Document.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit professors_signature_path(signature)
  end

  describe '#show', js: true do
    context 'when the document is reviewed' do
      it 'shows success message' do
        click_on_label('Deferir', in: 'document_judgment')
        find('.fa-bold').click

        find('button[id="save_document_judgment"]', text: save_button).click
        expect(page).to have_alert(text: message('update.m'))
      end
    end

    context 'when the document review is invalid' do
      it 'shows blank error message' do
        find('button[id="save_document_judgment"]', text: save_button).click
        expect(page).to have_alert(text: 'Preencha todos os campos!')
      end
    end
  end
end
