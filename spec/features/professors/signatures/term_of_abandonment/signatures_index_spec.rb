require 'rails_helper'

describe 'Signature::index', type: :feature do
  let(:professor) { create(:responsible) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the reviewing signatures' do
      it 'shows all the signatures' do
        document = create(:document_tdo)
        signature = create(:signature, user_id: professor.id, document_id: document.id)

        index_url = professors_signatures_reviewing_path
        visit index_url

        expect(page).to have_contents([signature.orientation.short_title,
                                       signature.orientation.academic.name,
                                       signature.document.document_type.name])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
