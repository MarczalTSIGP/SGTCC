require 'rails_helper'

describe 'Orientation::documents', :js do
  let!(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientation_documents_path(orientation)
  end

  describe '#index' do
    context 'when shows all the orientation documents' do
      let(:active_link) { responsible_orientations_tcc_one_path }

      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_link(document.orientation.short_title,
                                    href: responsible_orientation_document_path(orientation,
                                                                                document))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
        expect(page).to have_css("a[href='#{active_link}'].active")
      end
    end

    context 'when show the document by orientation' do
      let(:document) { orientation.documents.first }
      let(:active_link) { responsible_orientations_tcc_one_path }

      before do
        visit responsible_orientation_document_path(orientation, document)
      end

      it 'shows the document' do
        expect(page).to have_content(orientation.title)
        expect(page).to have_content(orientation.academic.name)
        expect(page).to have_content(orientation.academic.ra)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_css("a[href='#{active_link}'].active")
      end
    end
  end
end
