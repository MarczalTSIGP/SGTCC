require 'rails_helper'

describe 'Orientation::documents', :js do
  let!(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#show' do
    context 'when show the document by orientation' do
      let(:document) { orientation.documents.first }
      let(:active_link) { responsible_orientations_tcc_one_path }

      before do
        visit responsible_orientation_document_path(orientation, document)
      end

      it 'shows the document' do
        expect(page).to have_text(orientation.title)
        expect(page).to have_text(orientation.academic.name)
        expect(page).to have_text(orientation.academic.ra)
        expect(page).to have_text(orientation.advisor.name)
        expect(page).to have_css("a[href='#{active_link}'].active")
      end
    end
  end
end
