require 'rails_helper'

describe 'Signature::index', type: :feature do
  let(:orientation) { create(:orientation) }
  let(:external_member) { orientation.external_member_supervisors.first }

  before do
    orientation.signatures << Signature.all
    login_as(external_member, scope: :external_member)
  end

  describe '#index', js: true do
    let(:signatures) do
      orientation.signatures.where(user_type: :external_member_supervisor)
    end

    context 'when shows all the pending signatures' do
      it 'shows all the signatures' do
        index_url = external_members_signatures_pending_path
        visit index_url

        signatures.each do |signature|
          expect(page).to have_contents([signature.orientation.short_title,
                                         signature.orientation.academic.name,
                                         signature.document.document_type.name])
          expect(page).to have_selector("a[href='#{index_url}'].active")
        end
      end
    end

    context 'when shows all the signed signatures' do
      before do
        signatures.each(&:sign)
      end

      it 'shows all the signatures' do
        index_url = external_members_signatures_signed_path
        visit index_url

        signatures.each do |signature|
          expect(page).to have_contents([signature.orientation.short_title,
                                         signature.orientation.academic.name,
                                         signature.document.document_type.name])
          expect(page).to have_selector("a[href='#{index_url}'].active")
        end
      end
    end
  end
end
