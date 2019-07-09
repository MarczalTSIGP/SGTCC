require 'rails_helper'

describe 'Signature::index', type: :feature do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the pending signatures' do
      it 'shows all the signatures' do
        signature = create(:signature, user_id: professor.id)

        index_url = professors_signatures_pending_path
        visit index_url

        expect(page).to have_contents([signature.orientation.short_title,
                                       signature.orientation.academic.name,
                                       signature.document.document_type.name])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all the signed signatures' do
      it 'shows all the signatures' do
        signature = create(:signature_signed, user_id: professor.id)

        index_url = professors_signatures_signed_path
        visit index_url

        expect(page).to have_contents([signature.orientation.short_title,
                                       signature.orientation.academic.name,
                                       signature.document.document_type.name])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
