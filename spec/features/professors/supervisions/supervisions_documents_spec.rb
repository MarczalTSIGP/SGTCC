require 'rails_helper'

describe 'Supervision::documents', type: :feature, js: true do
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
          expect(page).to have_contents([document.orientation.short_title,
                                         document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end
  end
end
