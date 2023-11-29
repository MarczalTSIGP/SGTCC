require 'rails_helper'

describe 'Document::index', :js do
  let(:professor_tcc_one) { create(:professor_tcc_one) }
  let!(:orientation) { create(:orientation, advisor: professor_tcc_one) }

  before do
    login_as(professor_tcc_one, scope: :professor)
    visit tcc_one_professors_root_path
  end

  describe '#index' do
    context 'when shows all the pending documents' do
      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_link(document.orientation.short_title,
                                    href: tcc_one_professors_calendar_orientation_documents_path(
                                      document.orientation.current_calendar, document.orientation
                                    ))

          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
      end
    end
  end
end
