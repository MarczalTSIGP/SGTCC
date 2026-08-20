require 'rails_helper'

describe 'Orientation::documents show', :js do
  let!(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:orientation, :current, :tcc_one, advisor: professor) }
  let(:document) { orientation.documents.first }
  let(:active_link) do
    tcc_one_professors_calendar_orientations_path(orientation.current_calendar)
  end

  before do
    login_as(professor, scope: :professor)
    visit tcc_one_professors_calendar_orientation_document_path(
      orientation.current_calendar, orientation, document
    )
  end

  it_behaves_like 'orientation document show page'
end
