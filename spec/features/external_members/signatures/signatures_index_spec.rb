require 'rails_helper'

describe 'Signature::index', type: :feature do
  let(:external_member) { create(:external_member) }

  before do
    login_as(external_member, scope: :external_member)
  end

  describe '#index', js: true do
    context 'when shows all the pending signatures' do
      it 'shows all the signatures' do
        signature = create(:external_member_signature, user_id: external_member.id)

        index_url = external_members_signatures_pending_path
        visit index_url

        expect(page).to have_contents([signature.orientation.title,
                                       signature.orientation.academic.name,
                                       signature.document.document_type.name])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all the signed signatures' do
      it 'shows all the signatures' do
        signature = create(:external_member_signature_signed, user_id: external_member.id)

        index_url = external_members_signatures_signed_path
        visit index_url

        expect(page).to have_contents([signature.orientation.title,
                                       signature.orientation.academic.name,
                                       signature.document.document_type.name])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
