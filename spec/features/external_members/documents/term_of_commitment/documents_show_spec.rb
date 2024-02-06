require 'rails_helper'

describe 'Document::show', :js do
  let(:orientation) { create(:orientation) }
  let(:external_member) { orientation.external_member_supervisors.first }
  let(:document) { Document.first }

  before do
    orientation.signatures << Signature.all
    login_as(external_member, scope: :external_member)
  end

  describe '#show' do
    context 'when shows the signature of the term of commitment' do
      let(:active_link) { external_members_documents_pending_path }

      before do
        visit external_members_document_path(document)
      end

      it 'shows the document of the term of commitment' do
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

        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when shows the signed signature of the term of commitment' do
      let(:document_type) { document.document_type }
      let(:active_link) { external_members_documents_signed_path }

      before do
        document.signatures.each(&:sign)
        visit external_members_document_path(document)
      end

      it 'shows the document of the term of commitment' do
        role = signature_role(external_member.gender, 'external_member_supervisor')

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
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when the document signature cant be viewed' do
      before do
        create(:orientation)
        visit external_members_document_path(Document.last)
      end

      it 'redirect to the signature pending page' do
        expect(page).to have_current_path external_members_documents_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end
