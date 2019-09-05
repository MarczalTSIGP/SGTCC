require 'rails_helper'

describe 'Orientation::documents', type: :feature, js: true do
  let!(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:current_orientation_tcc_one, advisor: professor) }

  before do
    login_as(professor, scope: :professor)
    visit tcc_one_professors_calendar_orientation_documents_path(orientation.calendar, orientation)
  end

  describe '#index' do
    context 'when shows all the orientation documents' do
      let(:active_link) do
        tcc_one_professors_calendar_orientations_path(orientation.calendar)
      end

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
