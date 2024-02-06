require 'rails_helper'

describe 'Orientation::documents', :js do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:current_orientation_tcc_one, academic:) }
  let(:active_link) { academics_calendars_path }

  before do
    login_as(academic, scope: :academic)
    visit academics_calendar_orientation_documents_path(orientation.current_calendar, orientation)
  end

  describe '#index' do
    context 'when shows all the orientation documents' do
      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_link(document.orientation.short_title,
                                    href: academics_calendar_orientation_document_path(
                                      orientation.current_calendar, orientation, document
                                    ))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when show the document by orientation' do
      let(:document) { orientation.documents.first }

      before do
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

        orientation.supervisors do |supervisor|
          expect(page).to have_content(scholarity_with_name(supervisor))
        end

        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end
  end
end
