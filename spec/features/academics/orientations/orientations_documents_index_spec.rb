require 'rails_helper'

describe 'Orientation::documents index', :js do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, :current, :tcc_one, academic:) }
  let(:active_link) { academics_calendars_path }

  before do
    login_as(academic, scope: :academic)
    visit academics_calendar_orientation_documents_path(orientation.current_calendar, orientation)
  end

  it 'shows all the documents' do
    orientation.documents.each do |document|
      expect(page).to have_link(document.orientation.short_title,
                                href: academics_calendar_orientation_document_path(
                                  orientation.current_calendar, orientation, document
                                ))
      expect(page).to have_contents([document.orientation.academic.name,
                                     document.document_type.identifier.upcase])
    end
    expect(page).to have_css("a[href='#{active_link}'].active")
  end
end
