require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let!(:professor) { create(:professor) }
  let!(:academic) { create(:academic) }
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:orientation, advisor: professor) }
  let(:document_type) { create(:document_type_tco) }
  let(:document) { create(:document, document_type: document_type) }

  before do
    login_as(external_member, scope: :external_member)
    orientation.external_member_supervisors << external_member
  end

  describe '#show' do
    context 'when shows the signature of the term of commitment' do
      let!(:signature) do
        create(:external_member_signature,
               document: document,
               orientation_id: orientation.id,
               user_id: external_member.id)
      end

      it 'shows the document of the term of commitment' do
        visit external_members_signature_path(signature)
        academic = signature.orientation.academic
        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       document_date(orientation.created_at),
                                       academic.name,
                                       academic.email,
                                       academic.ra])
        active_link = external_members_signatures_pending_path
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when shows the signed signature of the term of commitment' do
      let!(:signature) do
        create(:external_member_signature_signed,
               document: document,
               orientation_id: orientation.id,
               user_id: external_member.id)
      end

      before do
        create(:signature_signed,
               orientation_id: orientation.id,
               user_id: professor.id)

        create(:academic_signature_signed,
               orientation_id: orientation.id,
               user_id: academic.id)

        orientation.external_member_supervisors << external_member
        visit external_members_signature_path(signature)
      end

      it 'shows the document of the term of commitment' do
        academic = orientation.academic
        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       signature_role(signature.user_type),
                                       document_date(orientation.created_at),
                                       academic.name,
                                       academic.email,
                                       academic.ra])
        orientation.signatures_mark.each do |signature|
          expect(page).to have_content(
            signature_register(signature[:name], signature[:role],
                               signature[:date], signature[:time])
          )
        end
        active_link = external_members_signatures_signed_path
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when the document signature cant be viewed' do
      before do
        professor_signature = create(:signature)
        visit external_members_signature_path(professor_signature)
      end

      it 'redirect to the signature pending page' do
        expect(page).to have_current_path external_members_signatures_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end
