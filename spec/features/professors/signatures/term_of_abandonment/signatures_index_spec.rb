require 'rails_helper'

describe 'Signature::index', type: :feature do
  let(:professor) { create(:responsible) }
  let!(:orientation) { create(:orientation, advisor_id: professor.id) }
  let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

  before do
    orientation.signatures << Signature.where(document_id: document.id)
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    let(:signatures) { orientation.signatures }

    context 'when shows all the reviewing signatures' do
      it 'shows all the signatures' do
        index_url = professors_signatures_reviewing_path
        visit index_url

        signatures.each do |signature|
          expect(page).to have_contents([signature.orientation.short_title,
                                         signature.orientation.academic.name,
                                         signature.document.document_type.identifier.upcase])
          expect(page).to have_selector("a[href='#{index_url}'].active")
        end
      end
    end
  end
end
