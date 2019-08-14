require 'rails_helper'

describe 'Document::show', type: :feature, js: true do
  let(:academic) { create(:academic) }
  let(:orientation) { create(:orientation, academic: academic) }
  let(:document) { Document.first }

  before do
    orientation.signatures << Signature.all
    login_as(academic, scope: :academic)
  end

  describe '#show' do
    context 'when shows the document of the term of commitment' do
      it 'shows the document of the term of commitment' do
        visit academics_document_path(document)

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

        expect(page).to have_selector("a[href='#{academics_documents_pending_path}'].active")
      end
    end

    context 'when shows the signed document of the term of commitment' do
      let(:document_type) { document.document_type }

      before do
        document.signatures.each(&:sign)
        visit academics_document_path(document)
      end

      it 'shows the document of the term of commitment' do
        role = signature_role(academic.gender, 'academic')
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

        document.mark.each do |signature|
          expect(page).to have_content(
            signature_register(signature[:name], signature[:role],
                               signature[:date], signature[:time])
          )
        end
        expect(page).to have_selector("a[href='#{academics_documents_signed_path}'].active")
      end
    end

    context 'when the document cant be viewed' do
      before do
        create(:orientation)
        visit academics_document_path(Document.last)
      end

      it 'redirect to the documents pending page' do
        expect(page).to have_current_path academics_documents_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end
