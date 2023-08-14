require 'rails_helper'

describe 'Supervision::documents', type: :feature, js: true do
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:current_orientation_tcc_one) }

  before do
    orientation.external_member_supervisors << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_supervision_documents_path(orientation)
  end

  describe '#index' do
    context 'when shows all the orientation documents' do
      let(:active_link) { external_members_supervisions_tcc_one_path }

      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_link(document.orientation.short_title, href: external_members_supervision_document_path(orientation, document))
          expect(page).to have_content(document.orientation.academic.name)
          expect(page).to have_content(document.document_type.identifier.upcase)
        end

        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when show the document by orientation' do
      let(:document) { orientation.documents.first }
      let(:active_link) { external_members_supervisions_tcc_one_path }

      before do
        visit external_members_supervision_document_path(orientation, document)
      end

      it 'shows the document' do
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
  end
end
