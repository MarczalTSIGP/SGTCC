require 'rails_helper'

describe 'Document::authenticate', type: :feature, js: true do
  let(:orientation) { create(:orientation) }

  before do
    orientation.signatures << Signature.all
    orientation.signatures.each(&:sign)
  end

  describe '#authenticate' do
    let(:document) { orientation.signatures.first.document }

    context 'when authenticate the signature code of the term of commitment' do
      it 'signs the document of the term of commitment' do
        visit document_path
        fill_in 'signature_code', with: document.code
        find('button[id="signature_authenticate_button"]', text: authenticate_button).click
        expect(page).to have_current_path confirm_document_code_path(document.code)
        expect(page).to have_alert(text: document_authenticated_message)
        find('button[class="swal-button swal-button--confirm"]', text: ok_button).click
      end
    end

    context 'when the code is wrong' do
      it 'shows alert message' do
        visit document_path
        fill_in 'signature_code', with: ''
        find('button[id="signature_authenticate_button"]', text: authenticate_button).click
        expect(page).to have_alert(text: invalid_code_message)
        find('button[class="swal-button swal-button--confirm"]', text: ok_button).click
      end
    end

    context 'when the not found code' do
      it 'shows alert message' do
        visit document_path
        fill_in 'signature_code', with: '343'
        find('button[id="signature_authenticate_button"]', text: authenticate_button).click
        expect(page).to have_alert(text: document_not_found_message)
      end
    end
  end
end
