require 'rails_helper'

describe 'Document::show', :js do
  let(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:document) { Document.first }

  before do
    orientation.signatures << Signature.all
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the pending document of the term of commitment' do
      let(:active_link) { professors_documents_pending_path }

      it 'shows the document of the term of commitment' do
        visit professors_document_path(document)

        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       document_date(document.created_at)])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(scholarity_with_name(supervisor))
        end

        expect(page).to have_css("a[href='#{active_link}'].active")
      end
    end

    context 'when shows the signed document of the term of commitment' do
      let(:document_type) { document.document_type }
      let(:active_link) { professors_documents_signed_path }

      before do
        document.signatures.each(&:sign)
        visit professors_document_path(document)
      end

      it 'shows the document of the term of commitment' do
        role = signature_role(professor.gender, 'advisor')

        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       role,
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
        expect(page).to have_css("a[href='#{active_link}'].active")
      end
    end

    context 'when the document cant be viewed' do
      before do
        create(:orientation)
        visit professors_document_path(Document.last)
      end

      it 'redirect to the documents pending page' do
        expect(page).to have_current_path professors_documents_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end
