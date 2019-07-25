require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let(:orientation) { create(:orientation) }

  before do
    orientation.signatures << Signature.all
    login_as(academic, scope: :academic)
  end

  describe '#show' do
    let(:signatures) { orientation.signatures }
    let(:academic_signature) { signatures.where(user_type: :academic).first }
    let(:academic) { academic_signature.user }

    context 'when shows the signature of the term of commitment' do
      it 'shows the document of the term of commitment' do
        visit academics_signature_path(academic_signature)

        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       document_date(orientation.created_at)])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(scholarity_with_name(supervisor))
        end

        expect(page).to have_selector("a[href='#{academics_signatures_pending_path}'].active")
      end
    end

    context 'when shows the signed signature of the term of commitment' do
      let(:document) { signatures.first.document }
      let(:document_type) { document.document_type }

      before do
        signatures.each(&:sign)
        visit academics_signature_path(academic_signature)
      end

      it 'shows the document of the term of commitment' do
        role = signature_role(academic.gender, academic_signature.user_type)
        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       role,
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
        expect(page).to have_selector("a[href='#{academics_signatures_signed_path}'].active")
      end
    end

    context 'when the document signature cant be viewed' do
      before do
        advisor_signature = orientation.signatures.where(user_type: :advisor)
        visit academics_signature_path(advisor_signature)
      end

      it 'redirect to the signature pending page' do
        expect(page).to have_current_path academics_signatures_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end
