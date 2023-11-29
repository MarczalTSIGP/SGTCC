require 'rails_helper'

describe 'Document::review', :js do
  let!(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation, advisor: responsible) }
  let(:document) { create(:document_tdo, orientation_id: orientation.id) }
  let(:resource_name) { Document.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit professors_document_path(document)
    end

    context 'when the document is reviewed' do
      it 'shows success message' do
        click_on_label(concede_label, in: 'document_judgment')
        fill_in_simple_mde('Hakuna Matata')
        find('button[id="save_document_judgment"]', text: save_button).click
        expect(page).to have_alert(text: message('update.m'))

        find('button[class="swal-button swal-button--confirm"]', text: ok_button).click
        expect(page).to have_contents([conceded_label, 'Hakuna Matata'])
      end
    end

    context 'when the document review is invalid' do
      it 'shows blank error message' do
        find('button[id="save_document_judgment"]', text: save_button).click
        expect(page).to have_alert(text: I18n.t('json.messages.empty_fields'))
      end
    end
  end

  describe '#update' do
    let(:responsible_json) do
      { accept: 'true', id: responsible.id, justification: 'justification' }
    end

    let(:request) do
      { requester: { justification: 'a' }, judgment: { responsible: responsible_json } }
    end

    let!(:new_document) do
      create(:document_tdo, orientation_id: orientation.id, request: request)
    end

    before do
      visit professors_document_path(new_document)
    end

    context 'when the document is updated' do
      it 'shows success message' do
        find_by_id('edit_button_judgment').click
        click_on_label(dismiss_label, in: 'document_judgment')
        fill_in_simple_mde('Hakuna Matata')

        sleep 1
        find('button[id="save_document_judgment"]', text: save_button).click

        expect(page).to have_alert(text: message('update.m'))
        find('button[class="swal-button swal-button--confirm"]', text: ok_button).click
        expect(page).to have_contents([dismissed_label, 'Hakuna Matata'])
      end
    end

    context 'when the document is not updated' do
      before do
        new_document.signatures.each(&:sign)
      end

      it 'shows errors message' do
        find_by_id('edit_button_judgment').click
        click_on_label(dismiss_label, in: 'document_judgment')
        find('.fa-bold').click

        find('button[id="save_document_judgment"]', text: save_button).click
        expect(page).to have_alert(text: document_errors_update_message)
      end
    end
  end
end
