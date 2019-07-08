require 'rails_helper'

describe 'Signature::authenticate', type: :feature, js: true do
  let!(:professor) { create(:professor) }
  let!(:external_member) { create(:external_member) }
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, advisor: professor, academic: academic) }
  let!(:document_type) { create(:document_type_tco) }
  let!(:document) { create(:document, document_type: document_type) }
  let!(:signature) do
    create(:signature_signed, orientation_id: orientation.id,
                              document: document,
                              user_id: professor.id)
  end

  before do
    create(:academic_signature_signed,
           document: document,
           orientation_id: orientation.id,
           user_id: academic.id)

    create(:external_member_signature_signed,
           orientation_id: orientation.id,
           user_id: external_member.id)

    orientation.external_member_supervisors << external_member
  end

  describe '#authenticate' do
    context 'when authenticate the signature code of the term of commitment' do
      it 'signs the document of the term of commitment' do
        visit signature_document_path
        fill_in 'signature_code', with: signature.signature_code.code
        find('button[id="signature_authenticate_button"]', text: authenticate_button).click
        expect(page).to have_current_path signature_path(signature.signature_code.code)
        expect(page).to have_alert(text: document_authenticated_message)
        find('button[class="swal-button swal-button--confirm"]', text: ok_button).click
      end
    end

    context 'when the code is wrong' do
      it 'shows alert message' do
        visit signature_document_path
        fill_in 'signature_code', with: ''
        find('button[id="signature_authenticate_button"]', text: authenticate_button).click
        expect(page).to have_alert(text: invalid_code_message)
        find('button[class="swal-button swal-button--confirm"]', text: ok_button).click
      end
    end

    context 'when the not found code' do
      it 'shows alert message' do
        visit signature_document_path
        fill_in 'signature_code', with: '343'
        find('button[id="signature_authenticate_button"]', text: authenticate_button).click
        expect(page).to have_alert(text: document_not_found_message)
      end
    end
  end
end
