require 'rails_helper'

describe 'Orientation::documents show', :js do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:current_orientation_tcc_one, academic:) }
  let(:active_link) { academics_calendars_path }
  let(:document) { orientation.documents.first }

  before do
    login_as(academic, scope: :academic)
    visit academics_calendar_orientation_document_path(
      orientation.current_calendar, orientation, document
    )
  end

  it 'shows the document' do
    expect(page).to have_contents([orientation.title,
                                   orientation.academic.name,
                                   orientation.academic.ra,
                                   orientation.institution.trade_name,
                                   orientation.institution.external_member.name,
                                   scholarity_with_name(orientation.advisor),
                                   document_date(orientation.created_at)])

    orientation.supervisors.each do |supervisor|
      expect(page).to have_text(scholarity_with_name(supervisor))
    end

    expect(page).to have_css("a[href='#{active_link}'].active")
  end
end
