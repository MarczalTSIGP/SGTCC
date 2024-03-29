require 'rails_helper'

describe 'Document::show', :js do
  let(:orientation) { create(:orientation) }

  before do
    orientation.signatures << Signature.all
    orientation.signatures.each(&:sign)
  end

  describe '#show' do
    let(:signatures) { orientation.signatures }
    let(:document) { signatures.first.document }
    let(:academic_signature) { signatures.where(user_type: :academic).first }
    let(:academic) { academic_signature.user }
    let(:document_type) { document.document_type }

    context 'when shows the signed signature of the term of commitment' do
      before do
        visit confirm_document_code_path(document.code)
      end

      it 'shows the document of the term of commitment' do
        expect(page).to have_alert(text: document_authenticated_message)
        click_button(ok_button, class: 'swal-button swal-button--confirm')

        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       signature_code_message(document),
                                       document_date(document.created_at)])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(scholarity_with_name(supervisor))
        end

        document.mark.each do |signature|
          expect(page).to have_content(
            signature_register(signature[:name], signature[:role],
                               signature[:date], signature[:time])
          )
        end
      end
    end

    context 'when the not found document' do
      before do
        code = 10.years.from_now.to_i
        visit confirm_document_code_path(code)
      end

      it 'redirect to the signature document page' do
        expect(page).to have_current_path document_path
        expect(page).to have_alert(text: document_not_found_message)
      end
    end
  end
end
