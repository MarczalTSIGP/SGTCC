require 'rails_helper'

describe 'Orientation::documents', :js do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:orientation, advisor: professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when show the document by orientation' do
      let(:document) { orientation.documents.first }

      before do
        visit professors_document_path(document)
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
      end

      it 'renders the document page with print and back actions' do
        expect(page).to have_text('Salvar documento em PDF')
        expect(page).to have_button('Salvar em PDF')
      end
    end
  end
end
