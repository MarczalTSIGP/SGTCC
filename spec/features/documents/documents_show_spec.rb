require 'rails_helper'

describe 'Document::show', type: :feature, js: true do
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

  describe '#show' do
    before do
      visit confirm_document_code_path(document.code)
    end

    context 'when shows the signed signature of the term of commitment' do
      it 'shows the document of the term of commitment' do
        expect(page).to have_alert(text: document_authenticated_message)
        find('button[class="swal-button swal-button--confirm"]', text: ok_button).click

        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       signature_role(academic.gender, signature.user_type),
                                       signature_code_message(document),
                                       document_date(orientation.created_at)])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(scholarity_with_name(supervisor))
        end

        Signature.mark(orientation.id, document_type.id).each do |signature|
          expect(page).to have_content(
            signature_register(signature[:name], signature[:role],
                               signature[:date], signature[:time])
          )
        end
      end
    end

    context 'when the not found document' do
      before do
        visit confirm_document_code_path('343445')
      end

      it 'redirect to the signature document page' do
        expect(page).to have_current_path document_path
        expect(page).to have_alert(text: document_not_found_message)
      end
    end
  end
end
