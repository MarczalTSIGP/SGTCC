require 'rails_helper'

describe 'Supervision::documents', :js do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:current_orientation_tcc_one) }

  before do
    orientation.professor_supervisors << professor
    login_as(professor, scope: :professor)
    visit professors_supervision_documents_path(orientation)
  end

  describe '#index' do
    context 'when shows all the orientation documents' do
      let(:active_link) { professors_supervisions_tcc_one_path }

      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_link(document.orientation.short_title,
                                    href: professors_document_path(document))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when show the document by orientation' do
      let(:document) { orientation.documents.first }
      let(:active_link) { professors_supervisions_tcc_one_path }

      before do
        visit professors_supervision_document_path(orientation, document)
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
