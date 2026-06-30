require 'rails_helper'

describe 'Orientation::documents index', :js do
  let!(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:current_orientation_tcc_one, advisor: professor) }
  let(:active_link) do
    tcc_one_professors_calendar_orientations_path(orientation.current_calendar)
  end

  before do
    login_as(professor, scope: :professor)
    visit tcc_one_professors_calendar_orientation_documents_path(orientation.current_calendar,
                                                                 orientation)
  end

  it 'shows all the documents' do
    orientation.documents.each do |document|
      expect(page).to have_link(document.orientation.title,
                                href: tcc_one_professors_calendar_orientation_document_path(
                                  orientation.current_calendar, orientation, document
                                ))

      expect(page).to have_contents([document.orientation.short_title,
                                     document.document_type.identifier.upcase])
    end
    expect(page).to have_css("a[href='#{active_link}'].active")
  end
end
